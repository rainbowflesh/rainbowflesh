param(
    [Parameter(Mandatory = $true)]
    [string]$name
)

$cmd = Get-Command $name -ErrorAction SilentlyContinue
if (-not $cmd) {
    Write-Host "Command not found: $name" -ForegroundColor Red
    exit 1
}

# Resolve alias if needed
if ($cmd.CommandType -eq 'Alias') {
    $targetCmd = Get-Command $cmd.Definition -ErrorAction SilentlyContinue
    $resolvedName = $name
    $resolvedTarget = $cmd.Definition
    $resolvedSource = if ($targetCmd) { $targetCmd.Source } else { "Unknown" }
}
else {
    $resolvedName = $cmd.Name
    $resolvedTarget = $cmd.Definition
    $resolvedSource = $cmd.Source
}

# Only show Source if it's different from Target
$output = [PSCustomObject]@{
    Name   = $resolvedName
    Target = $resolvedTarget
}

if ($resolvedTarget -ne $resolvedSource) {
    $output | Add-Member -NotePropertyName Source -NotePropertyValue $resolvedSource
}

$output | Format-Table -AutoSize
