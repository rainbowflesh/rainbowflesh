function Get-Fortune {
    param (
        [string] $filePath
    )

    # 读取整个文件的字节表示
    $fileBytes = [System.IO.File]::ReadAllBytes($filePath)

    # 解析文件结构
    # 第一个字节通常是文件的版本信息，可以忽略
    # 从第二个字节开始，读取每个条目

    $offset = 1  # 跳过版本信息
    $fortunes = @()

    while ($offset -lt $fileBytes.Length) {
        # 读取条目的长度（假设使用四字节整数表示）
        $entryLengthBytes = $fileBytes[$offset..($offset + 3)]
        $entryLength = [BitConverter]::ToInt32($entryLengthBytes, 0)
        $offset += 4  # 移动到下一个字节，跳过长度字段

        # 截取条目内容
        $fortuneBytes = $fileBytes[$offset..($offset + $entryLength - 1)]
        $fortuneText = [System.Text.Encoding]::ASCII.GetString($fortuneBytes)
        $offset += $entryLength  # 移动到下一个条目的起始位置

        # 添加到结果数组
        $fortunes += $fortuneText.Trim()
    }

    # 随机选择一个语录并返回
    return $fortunes | Get-Random
}

# 使用示例
$fortuneFile = "$HOME\Developments\dotfile\assets\chinese.dat"
$randomFortune = Get-Fortune -filePath $fortuneFile
Write-Output $randomFortune
