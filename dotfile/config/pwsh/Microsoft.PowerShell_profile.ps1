$SCRIPTS_DIR = "$HOME\Developments\rainbowflesh\src\scripts"

$themes = Get-ChildItem "$env:POSH_THEMES_PATH" -Filter *.omp.json | Select-Object -ExpandProperty FullName
$randomTheme = Get-Random -InputObject $themes
oh-my-posh init pwsh --config "$randomTheme" | Invoke-Expression

. $SCRIPTS_DIR\zoxide.ps1

Set-Alias -Name z -Value __zoxide_z -Option AllScope -Scope Global -Force
Set-Alias -Name zi -Value __zoxide_zi -Option AllScope -Scope Global -Force

Invoke-Expression (& { (zoxide init powershell | Out-String) })

Import-Module PSReadline -ErrorAction SilentlyContinue
Import-Module "$env:USERPROFILE\Documents\PowerShell\Modules\PSFzf\2.6.7\PSFzf.psm1" -ErrorAction SilentlyContinue

# Override PSReadLine's history search
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PsFzfOption -TabExpansion

# Override default tab completion
$PsFzfDesc = 'Uses PSReadline''s Completion results at any given cursor position and context ' +
'as the source for PsFzf''s module wrapper for fzf.exe'
$PsFzfParam = @{
    Chord            = 'Tab'
    BriefDescription = 'Fzf Tab Completion'
    Description      = $PsFzfDesc
    ScriptBlock      = { Invoke-FzfTabCompletion }
}
Set-PSReadLineKeyHandler @PsFzfParam
Set-PsFzfOption -TabContinuousTrigger "Tab"

# config eza
$env:EZA_CONFIG_DIR = "$env:USERPROFILE\.config\eza"

# Aliases
# script shortcuts
Set-Alias -Name dowaifu2x -Value "$SCRIPTS_DIR\waifu2x.ps1"
Set-Alias -Name killfilecoauth -Value "$SCRIPTS_DIR\kill_filecoauth.exe.ps1"

## Linux style aliases
function whereis {
    & "$SCRIPTS_DIR\whereis.ps1" @args
}

function cat {
    bat --theme="ansi" --style=plain @args
}

function ezals {
    eza --icons=auto --group-directories-first @args
}

Set-Alias -Name ls -Value "ezals" -Option AllScope
Set-Alias -Name l -Value "ezals" -Option AllScope
Set-Alias -Name cd -Value "z" -Option AllScope
Set-Alias -Name zip -Value "Compress-Archive" -Option AllScope
Set-Alias -Name vim -Value 'hx' -Option AllScope
Set-Alias -Name mklink -Value New-Item
Set-Alias -Name grep -Value Select-String
Set-Alias -Name which -Value Get-Command
Set-Alias -Name py -Value python