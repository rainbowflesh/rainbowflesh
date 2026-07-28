# png2jpg_final.ps1
# PowerShell 7+ recommended
# Requires: ImageMagick "magick" in PATH

$inputDir = "$HOME\Workspace\Photography\input_png2jpg"
$outputDir = "$HOME\Workspace\Photography\output"

$maxThreads = [Environment]::ProcessorCount
$maxRetry = 2
$failLogFile = Join-Path $outputDir "fail.log"

# 降低 ImageMagick 内部线程数，避免与 PowerShell 多线程冲突
$env:MAGICK_THREAD_LIMIT = "1"

$validExt = @(
    ".png", ".jpg", ".jpeg", ".webp",
    ".bmp", ".tiff", ".gif", ".heic",
    ".heif", ".avif"
)

if (-not (Test-Path $inputDir)) {
    throw "Input directory not found: $inputDir"
}

New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

function New-WorkerJob {
    param(
        [object]$Item,
        [object]$Pool,
        [scriptblock]$ScriptBlock
    )

    $ps = [powershell]::Create()
    $ps.RunspacePool = $Pool
    [void]$ps.AddScript($ScriptBlock.ToString())
    [void]$ps.AddArgument($Item.Input)
    [void]$ps.AddArgument($Item.Output)

    $handle = $ps.BeginInvoke()

    [pscustomobject]@{
        PowerShell = $ps
        Handle     = $handle
        Item       = $Item
    }
}

$queue = [System.Collections.Generic.Queue[object]]::new()
$running = [System.Collections.Generic.List[object]]::new()

$totalFiles = 0
$startedJobs = 0
$successCount = 0
$failCount = 0
$totalLatency = [int64] 0
$startTime = Get-Date

# 收集待处理文件
Get-ChildItem -Path $inputDir -Recurse -File | ForEach-Object {
    $file = $_

    if ($validExt -notcontains $file.Extension.ToLowerInvariant()) {
        return
    }

    $inputFile = $file.FullName
    $outputFile = Join-Path $outputDir ($file.BaseName + ".jpg")

    # 如果输出文件已存在，直接跳过（实现基本的增量处理）
    if (Test-Path $outputFile) {
        return
    }

    $queue.Enqueue([pscustomobject]@{
            Input  = $inputFile
            Output = $outputFile
            Retry  = 0
        })

    $totalFiles++
}

# Worker 脚本：在每个线程池任务中执行
$workerScript = {
    param(
        [string]$inputFile,
        [string]$outputFile
    )

    $ErrorActionPreference = "Stop"
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $tmpFile = "$outputFile.tmp.$PID.$([guid]::NewGuid().ToString('N')).jpg"

    try {
        & magick `
            $inputFile `
            -auto-orient `
            -colorspace sRGB `
            -background white -alpha remove -alpha off `
            -sampling-factor 4:4:4 `
            -quality 100 `
            -define jpeg:dct-method=float `
            -strip `
            -interlace Plane `
            -quiet `
            $tmpFile 2>$null

        if ($LASTEXITCODE -ne 0) {
            throw "ImageMagick exited with code $LASTEXITCODE."
        }

        if (-not (Test-Path $tmpFile)) {
            throw "Temporary output was not created."
        }

        Move-Item -Force -Path $tmpFile -Destination $outputFile

        $sw.Stop()

        [pscustomobject]@{
            Success = $true
            Input   = $inputFile
            Output  = $outputFile
            TimeMs  = [int64]$sw.ElapsedMilliseconds
            Error   = $null
        }
    }
    catch {
        $sw.Stop()

        if (Test-Path $tmpFile) {
            Remove-Item -Force -ErrorAction SilentlyContinue $tmpFile
        }

        [pscustomobject]@{
            Success = $false
            Input   = $inputFile
            Output  = $outputFile
            TimeMs  = [int64]$sw.ElapsedMilliseconds
            Error   = $_.Exception.Message
        }
    }
}

$pool = [runspacefactory]::CreateRunspacePool(1, $maxThreads)
$pool.Open()

try {
    while ($queue.Count -gt 0 -or $running.Count -gt 0) {

        # 填充运行队列
        while ($queue.Count -gt 0 -and $running.Count -lt $maxThreads) {
            $item = $queue.Dequeue()
            $running.Add((New-WorkerJob -Item $item -Pool $pool -ScriptBlock $workerScript)) | Out-Null
            $startedJobs++
        }

        # 检查已完成的任务
        for ($i = $running.Count - 1; $i -ge 0; $i--) {
            $job = $running[$i]

            if (-not $job.Handle.IsCompleted) {
                continue
            }

            try {
                $result = @($job.PowerShell.EndInvoke($job.Handle)) | Select-Object -First 1
            }
            catch {
                $result = [pscustomobject]@{
                    Success = $false
                    Input   = $job.Item.Input
                    Output  = $job.Item.Output
                    TimeMs  = 0
                    Error   = $_.Exception.Message
                }
            }

            $job.PowerShell.Dispose()
            $running.RemoveAt($i)

            if ($null -eq $result) {
                if ($job.Item.Retry -lt $maxRetry) {
                    $queue.Enqueue([pscustomobject]@{
                            Input  = $job.Item.Input
                            Output = $job.Item.Output
                            Retry  = $job.Item.Retry + 1
                        })
                }
                else {
                    $failCount++
                    Add-Content -Path $failLogFile -Encoding UTF8 -Value "$($job.Item.Input) :: no result"
                }
                continue
            }

            if ($result.Success) {
                $successCount++
                $totalLatency += [int64]$result.TimeMs
            }
            else {
                if ($job.Item.Retry -lt $maxRetry) {
                    $queue.Enqueue([pscustomobject]@{
                            Input  = $job.Item.Input
                            Output = $job.Item.Output
                            Retry  = $job.Item.Retry + 1
                        })
                }
                else {
                    $failCount++
                    Add-Content -Path $failLogFile -Encoding UTF8 -Value "$($result.Input) :: $($result.Error)"
                }
            }
        }

        Start-Sleep -Milliseconds 50
    }
}
finally {
    if ($pool) {
        $pool.Close()
        $pool.Dispose()
    }
}

$elapsed = (Get-Date) - $startTime
$seconds = [math]::Max($elapsed.TotalSeconds, 0.001)

$throughputSuccess = $successCount / $seconds
$avgLatency = if ($successCount -gt 0) { $totalLatency / $successCount } else { 0 }

Write-Host "`n==== STATS ====" -ForegroundColor Cyan
Write-Host ("Total files to process: {0}" -f $totalFiles)
Write-Host ("Success: {0}" -f $successCount)
Write-Host ("Fail:    {0}" -f $failCount)
Write-Host ("Elapsed: {0:N2} s" -f $elapsed.TotalSeconds)
Write-Host ("Throughput: {0:N2} img/s" -f $throughputSuccess)
Write-Host ("Avg latency: {0:N2} ms" -f $avgLatency)
Write-Host ("Fail log: {0}" -f $failLogFile)