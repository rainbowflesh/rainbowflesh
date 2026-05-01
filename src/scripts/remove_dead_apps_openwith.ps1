# Remove Foxit PDF Editor + Hebca PDF signature associations

$targets = @(
    "FoxitPDFEditor.exe",
    "txPDFSignature.exe"
)

# 1. Remove from Applications registry (Open With source)
foreach ($t in $targets) {
    $appKey = "Registry::HKEY_CLASSES_ROOT\Applications\$t"
    if (Test-Path $appKey) {
        Write-Output "Removing Applications entry: $t"
        Remove-Item $appKey -Recurse -Force
    }
}

# 2. Remove ProgID / Class leftovers
Get-ChildItem "Registry::HKEY_CLASSES_ROOT" | ForEach-Object {
    foreach ($t in $targets) {
        if ($_.Name -match "Foxit|Hebca|Seal|txPDF|Signature") {
            Write-Output "Removing ProgID: $($_.Name)"
            Remove-Item $_.PsPath -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# 3. Clean OpenWith for ALL extensions (important)
$extRoot = "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts"

Get-ChildItem $extRoot | ForEach-Object {

    $owp = Join-Path $_.PsPath "OpenWithProgids"
    $owl = Join-Path $_.PsPath "OpenWithList"

    # Clean ProgIds
    if (Test-Path $owp) {
        Get-ItemProperty $owp | ForEach-Object {
            $_.PSObject.Properties |
                Where-Object { $_.Name -match "Foxit|Hebca|Seal|txPDF|Signature" } |
                    ForEach-Object {
                        Remove-ItemProperty -Path $owp -Name $_.Name -ErrorAction SilentlyContinue
                        Write-Output "Removed ProgID from OpenWithProgids: $($_.Name)"
                    }
                }
            }

            # Clean OpenWithList
            if (Test-Path $owl) {
                Get-ItemProperty $owl | ForEach-Object {
                    $_.PSObject.Properties |
                        Where-Object { $_.Value -match "Foxit|Hebca|Seal|txPDF|Signature" } |
                            ForEach-Object {
                                Remove-ItemProperty -Path $owl -Name $_.Name -ErrorAction SilentlyContinue
                                Write-Output "Removed OpenWithList entry: $($_.Name)"
                            }
                        }
                    }
                }

                # 4. Remove Start Menu App associations (optional but useful)
                Get-ChildItem "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\App Paths" |
                    Where-Object { $_.Name -match "Foxit|Hebca|txPDF" } |
                        ForEach-Object {
                            Write-Output "Removing App Paths: $($_.Name)"
                            Remove-Item $_.PsPath -Recurse -Force -ErrorAction SilentlyContinue
                        }