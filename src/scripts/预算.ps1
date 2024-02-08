
function dialog {
    [double]$remain = Read-Host "兜里还剩多少? 默认为 0 大洋" 
    if ($remain -lt 23333) {
        Write-Host "什么穷鬼" -ForegroundColor Green
    }
    [double]$chummage = Read-Host "给房东上贡了多少? 默认一万0八十"
    if ($chummage = 0) {
        $default_chummage = 10080;
        Write-Host "使用默认值 $default_chummage"
        $chummage = $default_chummage;
    }
    [double]$salary = Read-Host "老板施舍你了多少?"
    if ($salary = 0) {
        $default_salary = 7300;
        Write-Host "使用默认值 $default_salary"
        $salary = $default_salary;
    }

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = '发工资了么?'
    $form.Size = New-Object System.Drawing.Size(300, 200)
    $form.StartPosition = 'CenterScreen'

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75, 120)
    $okButton.Size = New-Object System.Drawing.Size(75, 23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150, 120)
    $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = '发了么?'
    $form.Controls.Add($label)

    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Location = New-Object System.Drawing.Point(10, 40)
    $listBox.Size = New-Object System.Drawing.Size(260, 20)
    $listBox.Height = 80

    [void] $listBox.Items.Add('发了')
    [void] $listBox.Items.Add('没发')

    $form.Controls.Add($listBox)

    $form.Topmost = $true

    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $x = $listBox.SelectedItem
        if ($x -eq '发了') {
            $remain += $salary
        }
        [double]$WeChat = Read-Host "Input 张小龙吞噬了你多少 $"
        [double]$AliPay = Read-Host "Input 支付鸨吸入了你多少 $"
        [double]$output = ($chummage + $WeChat + $AliPay)
        [double]$resume = $remain - $output  
        if ($resume -lt 0) {
            Write-Host "入不敷出了嗷臭弟弟" -ForegroundColor Green
            Write-Host = "还剩 $resume 大洋" -ForegroundColor Red
        }
        Write-Host = "还剩 $resume 大洋" -ForegroundColor Blue
    }

}

. dialog