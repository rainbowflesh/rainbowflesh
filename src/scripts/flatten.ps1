# Root directory (current directory)
$root = (Get-Location).Path

# Get all files inside subdirectories (exclude root-level files)
Get-ChildItem -Path $root -Recurse -File | Where-Object {
    $_.DirectoryName -ne $root
} | ForEach-Object {

    $sourceFile = $_.FullName
    $fileName = $_.Name
    $targetPath = Join-Path $root $fileName

    if (Test-Path $targetPath) {

        # Compute hash for source and existing file
        $srcHash = (Get-FileHash $sourceFile -Algorithm SHA256).Hash
        $dstHash = (Get-FileHash $targetPath -Algorithm SHA256).Hash

        if ($srcHash -eq $dstHash) {
            # Same content, overwrite
            Move-Item -Path $sourceFile -Destination $targetPath -Force
        }
        else {
            # Different content, generate new name
            $base = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
            $ext  = [System.IO.Path]::GetExtension($fileName)
            $i = 1

            do {
                $newName = "${base}_$i$ext"
                $newPath = Join-Path $root $newName
                $i++
            } while (Test-Path $newPath)

            Move-Item -Path $sourceFile -Destination $newPath
        }
    }
    else {
        Move-Item -Path $sourceFile -Destination $targetPath
    }
}

# Remove empty directories
Get-ChildItem -Directory -Recurse | Sort-Object FullName -Descending | Remove-Item -Force