Write-Host "========= 文件重命名为不可逆操作, 执行前请备份 ========="

# 构造参数
$ContractCode = Read-Host "请输入立项号"
$ConstructSerial = Read-Host "请输入工期号"
$UnitSerial = Read-Host "请输入机组号"
$StandardNumber = Read-Host "请输入标准号"
$DeviceProviderIndex = Read-Host "请输入设备厂商索引"

# debug
# $ContractCode = "Ep481"
# $ConstructSerial = "01"
# $UnitSerial = "00"
# $StandardNumber = "8433"
# $DeviceProviderIndex = "002"
# $FolderPath = "C:\Users\catki\Desktop\test\尿素区热控电缆－安徽天康（集团）股份有限公司"
# $CsvPath = "C:\Users\catki\Desktop\test\设备资料台账-低压电缆.csv"

# 用户交互式输入路径
while (-Not (Test-Path -Path ($FolderPath = Read-Host "请输入文件所在目录路径"))) {
    Write-Host "❌文件夹路径不存在! 请重新输入。"
}

while (-Not (Test-Path -Path ($CsvPath = Read-Host "请输入CSV文件路径"))) {
    Write-Host "❌CSV文件路径不存在! 请重新输入。"
}

try {
    $CsvData = Import-Csv -Path $CsvPath -Header @("序号", "专业", "名称", "编号", "责任者", "日期", "页数", "份数", "备注")
}
catch {
    Write-Host "❌无法读取CSV文件, 请确认文件格式正确。"
    exit
}

foreach ($Row in $CsvData) {
    if (-not $Row.名称) { continue }

    $Files = Get-ChildItem -Path $FolderPath -Filter "*$($Row.名称)*.pdf"

    foreach ($File in $Files) {
        $FileIndex = [int]$Row.序号
        $NewFileName = (
            "{0}-{1}{2}-{3}-{4}-{5:D3}.pdf" -f `
                $ContractCode,
            $ConstructSerial,
            $UnitSerial,
            $StandardNumber,
            $DeviceProviderIndex,
            $FileIndex
        )

        Write-Host $File.NameString " >> " $NewFileName
        Rename-Item -Path $File.FullName -NewName $NewFilePath
    }
}

Write-Host "✔️文件重命名完成" -ForegroundColor Green
