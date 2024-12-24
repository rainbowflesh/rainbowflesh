$processes = Get-Process -Name 'FileCoAuth' -ErrorAction SilentlyContinue
if ($processes) {
    foreach ($process in $processes) {
        try {
            Stop-Process -Id $process.Id -Force
            Write-Host "Stopped process: $($process.Name) with ID: $($process.Id)"
        }
        catch {
            Write-Host "Failed to stop process: $($process.Name) with ID: $($process.Id). Error: $_"
        }
    }
}
else {
    Write-Host "No processes named 'FileCoAuth.exe' were found."
}