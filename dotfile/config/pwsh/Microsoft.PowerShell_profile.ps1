$SCRIPTS_DIR = "$HOME\Developments\rainbowflesh\src\scripts"
# $starships = "$HOME\.config\starships\"
# $starshipThemes = Get-ChildItem $starships | Where-Object { $_.PSIsContainer -eq $false }
# $fileCount = $starshipThemes.Count

# # init starship
# $ENV:STARSHIP_CONFIG = "$starships\$randomFile"
# Invoke-Expression (&starship init powershell)
# Invoke-Expression (& {
#         $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
#     (zoxide init --hook $hook powershell | Out-String)
#     })

# if ($fileCount -gt 0) {
#     $randomIndex = Get-Random -Minimum 0 -Maximum $fileCount
#     $randomFile = $starshipThemes[$randomIndex].Name
#     Write-Host " [starship] Random theme $randomFile loaded"
# }

$themes = Get-ChildItem "$env:POSH_THEMES_PATH" -Filter *.omp.json | Select-Object -ExpandProperty FullName
$randomTheme = Get-Random -InputObject $themes
oh-my-posh init pwsh --config "$randomTheme" | Invoke-Expression

Import-Module -Name Terminal-Icons

if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadLine

    # Binding for moving through history by prefix
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

Import-Module PSFzf -ErrorAction SilentlyContinue
function Invoke-FzfTabCompletionOverride {
    $script:continueCompletion = $true
    do {
        $script:continueCompletion = Invoke-FzfTabCompletionInner
    } while ($script:continueCompletion)
}

# Override PSReadLine's history search
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'

# Override default tab completion
$PsFzfDesc = 'Uses PSReadline''s Completion results at any given cursor position and context ' +
'as the source for PsFzf''s module wrapper for fzf.exe'
$PsFzfParam = @{
    Chord            = 'Tab,Tab'
    BriefDescription = 'Fzf Tab Completion'
    Description      = $PsFzfDesc
    ScriptBlock      = { Invoke-FzfTabCompletionOverride }
}
Set-PSReadLineKeyHandler @PsFzfParam

# Aliases
# script shortcuts
Set-Alias -Name dowaifu2x -Value "$SCRIPTS_DIR\waifu2x.ps1"
Set-Alias -Name killfilecoauth -Value "$SCRIPTS_DIR\kill_filecoauth.exe.ps1"

## Linux style
Set-Alias -Name cat -Value bat -Option AllScope # --theme="Solarized (light)" --style=plain
Set-Alias -Name cd -Value "z" -Option AllScope
Set-Alias -Name grep -Value Select-String
Set-Alias -Name l -Value 'ls'
Set-Alias -Name mklink -Value New-Item -Option AllScope -Description 'Creates a symbolic link'
Set-Alias -Name vim -Value 'hx'
Set-Alias -Name whereis -Value Get-Command
Set-Alias -Name which -Value Get-Command
Set-Alias -Name py -Value python
