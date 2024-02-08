# Clock down
echo starting...
echo 'Please close manually if the windows no response.'
# Boot app
C:\Users\isri\AppData\Local\Microsoft\WindowsApps\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe\WsaClient.exe /launch wsa://com.teslacoilsw.launcher
echo 'app started'
adb connect 127.0.0.1:58526

# Get host ipv4
echo 'getting host ipv4...'
$MyIpv4 = Get-netipAddress | Where-Object {
  $_.InterfaceAlias -eq 'Wi-Fi' -and $_.AddressFamily -eq 'IPv4'
} | Select-Object IPAddress | Format-Table -HideTableHeaders | Out-String 
$MyIpv4 = $MyIpv4.Trim()

# Set port
$MyPort = 10809

# Set Porxyaddr
$Porxyaddr = $MyIpv4+':'+$MyPort

# Set following proxy 
adb shell settings put global http_proxy $Porxyaddr

echo 'The following proxy is'
adb shell settings get global http_proxy

Timeout /T 3
exit