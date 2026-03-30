# Source directory
$srcDir = "C:\Users\catki\Documents\豫辉工程\Documents\2026投标\社保"

# Destination directory
$destDir = Join-Path $env:USERPROFILE "Desktop\unlock"

# PDFDeSecure path
$pdfExe = "C:\Users\catki\AppData\Local\Programs\PDFDeSecure-master\PDFDeSecure\bin\windows\Release\net8.0-windows\PDFDeSecure.exe"

# Ensure destination exists
New-Item -ItemType Directory -Path $destDir -Force | Out-Null

$resolvedSrc = (Resolve-Path $srcDir).Path
$files = Get-ChildItem -Path $srcDir -Recurse -File -Filter "*.pdf"

Write-Host "Found $($files.Count) PDF files"
Write-Host "Output root: $destDir"
Write-Host ""

# 初始化序号计数器
$counter = 1

foreach ($file in $files) {

    $sourceFile = $file.FullName
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $extension = $file.Extension

    # 生成新文件名 xxx_序号.pdf
    $newName = "${baseName}_$counter$extension"
    $targetPath = Join-Path $destDir $newName

    Write-Host "Input : $sourceFile"z
    Write-Host "Output: $targetPath"

    # 调用 PDFDeSecure
    & $pdfExe "$sourceFile" "$targetPath"

    if (Test-Path $targetPath) {
        $size = (Get-Item $targetPath).Length
        Write-Host "OK     ($size bytes)"
    }
    else {
        Write-Host "FAILED (file not created)"
    }

    Write-Host ""

    $counter++
}

Write-Host "All done"