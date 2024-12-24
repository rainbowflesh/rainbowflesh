@(set "0=%~f0"^)#) & powershell -nop -c iex([io.file]::ReadAllText($env:0)) & exit /b
#:: double-click to run or just copy-paste into powershell - it's a standalone hybrid script
sp 'HKCU:\Volatile Environment' 'Edge_Removal' @'

$also_remove_webview = 1
# Teams 2.0 (no work account support yet)
winget uninstall MicrosoftTeams_8wekyb3d8bbwe

# Your Phone
winget uninstall Microsoft.YourPhone_8wekyb3d8bbwe

# Widgets (Web Experience Pack)
winget uninstall MicrosoftWindows.Client.WebExperience_cw5n1h2txyewy

# Cortana
winget uninstall Microsoft.549981C3F5F10_8wekyb3d8bbwe

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\SysTray" /v "Services" /t reg_dword /d 29 /f

## ask to run script as admin
'@.replace("$@","'@").replace("@$","@'") -force -ea 0;
$A = '-nop -noe -c & {iex((gp ''Registry::HKEY_Users\S-1-5-21*\Volatile*'' Edge_Removal -ea 0)[0].Edge_Removal)}'
start powershell -args $A -verb runas
$_Press_Enter
#::
