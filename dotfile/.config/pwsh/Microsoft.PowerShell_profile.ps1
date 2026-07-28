$SCRIPTS_DIR = "$HOME\Developments\rainbowflesh\src\scripts"

# $starships = "$HOME\.config\starships\"
# $files = Get-ChildItem $starships | Where-Object { $_.PSIsContainer -eq $false }
# $fileCount = $files.Count
# if ($fileCount -gt 0) {
#     $randomIndex = Get-Random -Minimum 0 -Maximum $fileCount
#     $randomFile = $files[$randomIndex].Name
#     Write-Host " [starship] Random theme $randomFile loaded"
# }

# $ENV:STARSHIP_CONFIG = "$starships\$randomFile"
# Invoke-Expression (&starship init powershell)
# Invoke-Expression (& {
#         $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
#     (zoxide init --hook $hook powershell | Out-String)
#     })

# oh my posh random theme
$themes = Get-ChildItem "$ENV:POSH_THEMES_PATH" -Filter *.omp.json | Select-Object -ExpandProperty FullName
$randomTheme = Get-Random -InputObject $themes
oh-my-posh init pwsh --config "$randomTheme" | Invoke-Expression

# init conda
Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1"

# config eza
$ENV:EZA_CONFIG_DIR = "$ENV:USERPROFILE\.config\eza"
# init fzf
$ENV:FZF_DEFAULT_OPTS = @"
    --color=fg:#908caa,bg:#191724,hl:#ebbcba
    --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
    --color=border:#403d52,header:#31748f,gutter:#191724
    --color=spinner:#f6c177,info:#9ccfd8
    --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
"@

# init zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
$ZoxideFzfOpts = '--layout=reverse --height=30%'
$ENV:_ZO_FZF_OPTS = "$ENV:FZF_DEFAULT_OPTS $ZoxideFzfOpts"

# init PSReadline
Import-Module PSReadline -ErrorAction SilentlyContinue
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# init PSFzf
Import-Module PSFzf
# PSFzf fzf options
$ENV:_PSFZF_FZF_DEFAULT_OPTS = "$ENV:FZF_DEFAULT_OPTS $ZoxideFzfOpts --preview-window 'hidden'"
# Override PSReadLine's history search
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'

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

function ln ($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}

function hln ($target, $link) {
    New-Item -Path $link -ItemType HardLink -Value $target
}

Set-Alias -Name grep -Value Select-String
Set-Alias -Name which -Value Get-Command

Set-Alias -Name ls -Value "ezals" -Option AllScope
Set-Alias -Name l -Value "ezals" -Option AllScope
Set-Alias -Name cd -Value "z" -Option AllScope
Set-Alias -Name cdr -Value "zi" -Option AllScope
Set-Alias -Name zip -Value "Compress-Archive" -Option AllScope
Set-Alias -Name vim -Value 'hx' -Option AllScope
Set-Alias -Name py -Value 'python' -Option AllScope
