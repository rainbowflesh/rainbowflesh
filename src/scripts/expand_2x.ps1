# expand_2x_to_out.ps1

$inputDir = "$HOME\Workspace\Photography\input_expand2x"
$outputDir = "$HOME\Workspace\Photography\output"

if (-not (Test-Path $inputDir)) {
    throw "Input directory not found: $inputDir"
}

New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

$workers = [Math]::Max(1, [Environment]::ProcessorCount - 1)

$validExt = @(
    ".png", ".jpg", ".jpeg", ".webp",
    ".bmp", ".tif", ".tiff", ".gif",
    ".heic", ".heif", ".avif"
)

$env:MAGICK_THREAD_LIMIT = "1"

function Start-WorkerJob {
    param(
        [string]$InputFile,
        [string]$OutputFile,
        [object]$Pool
    )

    $scriptBlock = {
        param($inputFile, $outputFile)

        $ErrorActionPreference = "Stop"
        $tmpFile = "$outputFile.tmp.$PID.$([guid]::NewGuid().ToString('N')).png"

        try {
            magick `
                "$inputFile" `
                -filter Lanczos `
                -resize 200% `
                -colorspace sRGB `
                -strip `
                "$tmpFile"

            if (-not (Test-Path $tmpFile)) {
                throw "ImageMagick failed"
            }

            Move-Item -Force $tmpFile $outputFile

            [pscustomobject]@{
                Success = $true
                File    = $inputFile
            }
        }
        catch {
            if (Test-Path $tmpFile) {
                Remove-Item -Force $tmpFile -ErrorAction SilentlyContinue
            }

            [pscustomobject]@{
                Success = $false
                File    = $inputFile
                Error   = $_.Exception.Message
            }
        }
    }

    $ps = [powershell]::Create()
    $ps.RunspacePool = $Pool
    $ps.AddScript($scriptBlock.ToString()) | Out-Null
    $ps.AddArgument($InputFile) | Out-Null
    $ps.AddArgument($OutputFile) | Out-Null

    $handle = $ps.BeginInvoke()

    return [pscustomobject]@{
        PowerShell = $ps
        Handle     = $handle
    }
}

$pool = [runspacefactory]::CreateRunspacePool(1, $workers)
$pool.Open()

$running = New-Object System.Collections.Generic.List[object]

$files = Get-ChildItem -Path $inputDir -Recurse -File |
    Where-Object { $validExt -contains $_.Extension.ToLowerInvariant() }

try {
    foreach ($file in $files) {

        $outputFile = Join-Path $outputDir ($file.BaseName + ".jpg")

        # 跳过已存在
        if (Test-Path $outputFile) {
            continue
        }

        while ($running.Count -ge $workers) {
            for ($i = $running.Count - 1; $i -ge 0; $i--) {
                $job = $running[$i]
                if ($job.Handle.IsCompleted) {
                    $result = $job.PowerShell.EndInvoke($job.Handle)
                    $job.PowerShell.Dispose()
                    $running.RemoveAt($i)

                    if ($result.Success) {
                        Write-Host "[OK] $($result.File)"
                    }
                    else {
                        Write-Host "[ERR] $($result.File)"
                    }
                }
            }
            Start-Sleep -Milliseconds 20
        }

        $running.Add((Start-WorkerJob -InputFile $file.FullName -OutputFile $outputFile -Pool $pool)) | Out-Null
    }

    while ($running.Count -gt 0) {
        for ($i = $running.Count - 1; $i -ge 0; $i--) {
            $job = $running[$i]
            if ($job.Handle.IsCompleted) {
                $result = $job.PowerShell.EndInvoke($job.Handle)
                $job.PowerShell.Dispose()
                $running.RemoveAt($i)

                if ($result.Success) {
                    Write-Host "[OK] $($result.File)"
                }
                else {
                    Write-Host "[ERR] $($result.File)"
                }
            }
        }
        Start-Sleep -Milliseconds 20
    }
}
finally {
    $pool.Close()
    $pool.Dispose()
}