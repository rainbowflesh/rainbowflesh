Write-Host "Starting Process..."
Write-Output ""

$input_file_path = "C:\Users\isri\Desktop\in"
$output_file_path = "C:\Users\isri\Desktop\out"

$before_count = [System.IO.Directory]::GetFiles($output_file_path).Count 
$total_input = [System.IO.Directory]::GetFiles($input_file_path).Count - 1 # Uncount script file

# Print the waifu2x parameter
Write-Host "<Waifu2x Detail>"
Write-Host "[Input Directory]  $input_file_path" -ForegroundColor Green
Write-Host "[Output Directory]  $output_file_path" -ForegroundColor Green
Write-Host "[File in the output directory] $before_count"
Write-Host "[Queried image count]  $total_input" -ForegroundColor Yellow
Write-Host "[Used GPU]" -ForegroundColor Magenta

# Main program
waifu2x -i $input_file_path -o $output_file_path

$after_count = [System.IO.Directory]::GetFiles($output_file_path).Count 
$total_output = ($after_count - $before_count)
Write-Host "Processed image count:"$total_output -ForegroundColor Red
Write-Host Done!

pause




