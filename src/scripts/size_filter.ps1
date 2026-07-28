# filter_move_to_expand_parallel.ps1
# PowerShell 7+ recommended
# Requires ImageMagick "magick" in PATH

$rootDir = "$HOME\Pictures\wallpapers"
$expandDir = "$HOME\Workspace\Photography\input_expand2x"

New-Item -ItemType Directory -Force -Path $expandDir | Out-Null

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
        [string]$ExpandDir,
        [object]$Pool
    )

    $scriptBlock = {
        param($inputFile, $expandDir)

        $ErrorActionPreference = "Stop"

        try {
            $size = & magick identify -format "%w %h" "$inputFile" 2>$null
            if (-not $size) {
                throw "Failed to read image size."
            }

            $parts = $size.Trim() -split '\s+'
            if ($parts.Count -lt 2) {
                throw "Invalid size output: $size"
            }

            $w = [int]$parts[0]
            $h = [int]$parts[1]

            $move = $false

            # Portrait
            if ($h -gt $w) {
                if ($w -lt 1080 -or $h -lt 2340) {
                    $move = $true
                }
            }
            # Landscape or square
            else {
                if ($w -lt 2560 -or $h -lt 1600) {
                    $move = $true
                }
            }

            if (-not $move) {
                return [pscustomobject]@{
                    Input   = $inputFile
                    Success = $true
                    Moved   = $false
                    Error   = $null
                }
            }

            $target = Join-Path $expandDir ([System.IO.Path]::GetFileName($inputFile))

            if (Test-Path $target) {
                $base = [System.IO.Path]::GetFileNameWithoutExtension($inputFile)
                $ext = [System.IO.Path]::GetExtension($inputFile)
                $target = Join-Path $expandDir ("{0}_{1}{2}" -f $base, ([guid]::NewGuid().ToString("N")), $ext)
            }

            Move-Item -Force -Path $inputFile -Destination $target

            return [pscustomobject]@{
                Input   = $inputFile
                Success = $true
                Moved   = $true
                Error   = $null
            }
        }
        catch {
            return [pscustomobject]@{
                Input   = $inputFile
                Success = $false
                Moved   = $false
                Error   = $_.Exception.Message
            }
        }
    }

    $ps = [powershell]::Create()
    $ps.RunspacePool = $Pool
    [void]$ps.AddScript($scriptBlock.ToString())
    [void]$ps.AddArgument($InputFile)
    [void]$ps.AddArgument($ExpandDir)

    $handle = $ps.BeginInvoke()

    [pscustomobject]@{
        PowerShell = $ps
        Handle     = $handle
    }
}

$pool = [runspacefactory]::CreateRunspacePool(1, $workers)
$pool.Open()

$running = New-Object System.Collections.Generic.List[object]

$files = Get-ChildItem -Path $rootDir -Recurse -File |
    Where-Object {
        $_.FullName -notlike "$expandDir*"
    } |
        Where-Object {
            $validExt -contains $_.Extension.ToLowerInvariant()
        }

try {
    foreach ($file in $files) {
        while ($running.Count -ge $workers) {
            for ($i = $running.Count - 1; $i -ge 0; $i--) {
                $job = $running[$i]
                if ($job.Handle.IsCompleted) {
                    $result = @($job.PowerShell.EndInvoke($job.Handle))[0]
                    $job.PowerShell.Dispose()
                    $running.RemoveAt($i)

                    if ($result.Success) {
                        if ($result.Moved) {
                            Write-Host "[MOVE] $($result.Input)"
                        }
                    }
                    else {
                        Write-Host "[ERR] $($result.Input) :: $($result.Error)"
                    }
                }
            }
            Start-Sleep -Milliseconds 20
        }

        $running.Add((Start-WorkerJob -InputFile $file.FullName -ExpandDir $expandDir -Pool $pool)) | Out-Null
    }

    while ($running.Count -gt 0) {
        for ($i = $running.Count - 1; $i -ge 0; $i--) {
            $job = $running[$i]
            if ($job.Handle.IsCompleted) {
                $result = @($job.PowerShell.EndInvoke($job.Handle))[0]
                $job.PowerShell.Dispose()
                $running.RemoveAt($i)

                if ($result.Success) {
                    if ($result.Moved) {
                        Write-Host "[MOVE] $($result.Input)"
                    }
                }
                else {
                    Write-Host "[ERR] $($result.Input) :: $($result.Error)"
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