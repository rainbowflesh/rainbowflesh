# Remove SumatraPDF file associations globally

# 1. Remove ProgID definitions (SumatraPDF classes)
Get-ChildItem "Registry::HKEY_CLASSES_ROOT" |
Where-Object { $_.Name -match "SumatraPDF" } |
ForEach-Object {
    Write-Output "Removing ProgID: $($_.Name)"
    Remove-Item $_.PsPath -Recurse -Force -ErrorAction SilentlyContinue
}

# 2. Remove application registration (Open With source)
Remove-Item "Registry::HKEY_CLASSES_ROOT\Applications\SumatraPDF.exe" -Recurse -Force -ErrorAction SilentlyContinue

# 3. Clean all file extensions OpenWith references
$extPath = "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts"

Get-ChildItem $extPath | ForEach-Object {
    $owp = Join-Path $_.PsPath "OpenWithProgids"
    $owl = Join-Path $_.PsPath "OpenWithList"

    if (Test-Path $owp) {
        Get-ItemProperty $owp | ForEach-Object {
            $_.PSObject.Properties |
            Where-Object { $_.Name -match "SumatraPDF" } |
            ForEach-Object {
                Write-Output "Removing ProgID from $owp : $($_.Name)"
                Remove-ItemProperty -Path $owp -Name $_.Name -ErrorAction SilentlyContinue
            }
        }
    }

    if (Test-Path $owl) {
        Get-ItemProperty $owl | ForEach-Object {
            $_.PSObject.Properties |
            Where-Object { $_.Value -match "SumatraPDF" } |
            ForEach-Object {
                Write-Output "Removing OpenWithList entry from $owl : $($_.Name)"
                Remove-ItemProperty -Path $owl -Name $_.Name -ErrorAction SilentlyContinue
            }
        }
    }
}