# ==============================================================================
# DaVinci Resolve 免费版 10-bit 4:2:2 视频批量转码脚本 (FFmpeg)
# 支持格式: H.264/H.265 10-bit 4:2:2 -> ProRes 422 HQ (10-bit) / DNxHR HQX (10-bit)
# ==============================================================================

# ================= 配置区域 =================
# 输入文件夹 (摄影原始素材路径)
$InputFolder = "$Home/Workspace/Photography/raw"

# 输出文件夹
# 注：如果你在 Windows 下想输出到 D 盘，请将该行修改为: $OutputFolder = "D:\Workspace\Photography\output\video"
$OutputFolder = "$Home/Workspace/Photography/raw/transcoded"

# 转码目标格式选择:
# "prores"  -> Apple ProRes 422 HQ (10-bit) - 强烈推荐，全平台达芬奇兼容性最佳
# "dnxhr"   -> Avid DNxHR HQX (10-bit)      - 达芬奇原生支持的另一个工业级编码
$TargetCodec = "dnxhr"
# ============================================

# 检查 FFmpeg 是否可用
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Write-Error "在系统中找不到 FFmpeg，请先安装 FFmpeg 并将其加入环境变量 PATH 中。"
    exit
}

# 确保输出目录存在
if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Force -Path $OutputFolder | Out-Null
    Write-Host "已创建输出文件夹: $OutputFolder" -ForegroundColor Green
}

# 检查输入目录
if (-not (Test-Path $InputFolder)) {
    Write-Error "找不到输入文件夹: $InputFolder，请检查路径是否正确。"
    exit
}

# 扫描支持的视频文件格式 (.mp4, .mov, .mkv, .mts)
$VideoFiles = Get-ChildItem -Path $InputFolder -File | Where-Object { $_.Extension -match '^\.(mp4|mov|mkv|mts)$' }

if ($VideoFiles.Count -eq 0) {
    Write-Host "在 $InputFolder 中未找到需要转码的视频文件。" -ForegroundColor Yellow
    exit
}

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host " 找到 $($VideoFiles.Count) 个视频，准备使用 FFmpeg 转码为 $TargetCodec..." -ForegroundColor Cyan
Write-Host " 输入目录: $InputFolder" -ForegroundColor Gray
Write-Host " 输出目录: $OutputFolder" -ForegroundColor Gray
Write-Host "==============================================" -ForegroundColor Cyan

$SuccessCount = 0
$FailedCount = 0

foreach ($File in $VideoFiles) {
    $InputFile = $File.FullName
    # 统一输出为 .mov 容器（ProRes 和 DNxHR 的标准载体）
    $OutputFile = Join-Path $OutputFolder "$($File.BaseName)_transcoded.mov"

    Write-Host "`n正在处理: $($File.Name) -> $(Split-Path $OutputFile -Leaf)" -ForegroundColor DarkCyan

    # 配置 FFmpeg 参数
    if ($TargetCodec -eq "prores") {
        # -c:v prores_ks: 使用高品质 ProRes 编码器
        # -profile:v 3: 对应 ProRes 422 HQ 规格
        # -pix_fmt yuv422p10le: 强制保持 10-bit 4:2:2 色彩采样
        # -c:a pcm_s24le: 音频转为无损线性 PCM 24-bit 格式，避免达芬奇音频解码问题
        $ffmpegArgs = @("-y", "-i", $InputFile, "-c:v", "prores_ks", "-profile:v", "3", "-pix_fmt", "yuv422p10le", "-c:a", "pcm_s24le", $OutputFile)
    }
    elseif ($TargetCodec -eq "dnxhr") {
        # -c:v dnxhd: 使用 Avid DNx 编码器家族
        # -profile:v dnxhr_hqx: 对应 10-bit 4:2:2 的 High Quality Extended 规格
        # -pix_fmt yuv422p10le: 强制保持 10-bit 4:2:2 色彩采样
        # -c:a pcm_s24le: 音频转为无损线性 PCM 24-bit
        $ffmpegArgs = @("-y", "-i", $InputFile, "-c:v", "dnxhd", "-profile:v", "dnxhr_hqx", "-pix_fmt", "yuv422p10le", "-c:a", "pcm_s24le", $OutputFile)
    }
    else {
        Write-Error "未知的目标编码格式: $TargetCodec。请修改脚本配置区域的 `$TargetCodec 变量。"
        exit
    }

    # 执行转码
    & ffmpeg $ffmpegArgs

    if ($LASTEXITCODE -eq 0) {
        Write-Host "转码成功: $($File.Name)" -ForegroundColor Green
        $SuccessCount++
    }
    else {
        Write-Host "转码失败: $($File.Name)" -ForegroundColor Red
        $FailedCount++
    }
}

Write-Host "`n==============================================" -ForegroundColor Cyan
Write-Host " 任务完成！" -ForegroundColor Green
Write-Host " 成功: $SuccessCount" -ForegroundColor Green
Write-Host " 失败: $FailedCount" -ForegroundColor ($FailedCount -gt 0 ? "Red" : "Gray")
Write-Host "==============================================" -ForegroundColor Cyan