param(
    [ValidateSet("default", "nsfw", "both")]
    [string]$Mode = "default"
)

# Wallpaper root
$root = "C:\Users\catki\Pictures"

# Select folders
$folders = switch ($Mode) {
    "default" { @("$root\background") }
    "nsfw" { @("$root\background_nsfw") }
    "both" { @("$root\background", "$root\background_nsfw") }
}

# Supported formats
$exts = "*.jpg", "*.jpeg", "*.png", "*.bmp", "*.webp"

# Collect images
$images = foreach ($folder in $folders) {
    Get-ChildItem `
        -Path $folder `
        -Recurse `
        -Include $exts `
        -File `
        -ErrorAction SilentlyContinue
}

if (-not $images) {
    throw "No images found"
}

# Pick random image
$image = $images | Get-Random

# Set desktop wallpaper
Set-ItemProperty `
    -Path "HKCU:\Control Panel\Desktop" `
    -Name Wallpaper `
    -Value $image.FullName

rundll32.exe user32.dll, UpdatePerUserSystemParameters

# Load WinRT lockscreen API
Add-Type -AssemblyName System.Runtime.WindowsRuntime

[Windows.System.UserProfile.LockScreen, Windows.System.UserProfile, ContentType = WindowsRuntime] | Out-Null

# Convert path to StorageFile
$storageFile = [Windows.Storage.StorageFile]::GetFileFromPathAsync($image.FullName).GetAwaiter().GetResult()

# Set lockscreen image
[Windows.System.UserProfile.LockScreen]::SetImageFileAsync($storageFile).GetAwaiter().GetResult()