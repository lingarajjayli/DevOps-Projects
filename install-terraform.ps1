Param(
    [string]$Version = "1.9.4",
    [string]$Path = "C:\Users\$env:USERNAME\AppData\Local"
)

$baseUrl = "https://releases.hashicorp.com/terraform/"
$filename = "terraform_{$Version}_windows_amd64.zip"
$url = "$baseUrl$Version/$filename"

Write-Host "Downloading Terraform v$Version..."
Invoke-WebRequest -Uri $url -OutFile "$Path\terraform.zip"

Write-Host "Extracting..."
Expand-Archive -Path "$Path\terraform.zip" -DestinationPath "$Path\" -Force

Write-Host "Removing zip..."
Remove-Item "$Path\terraform.zip" -Force

Write-Host "Adding to PATH..."
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
$envPath = $oldPath + ";$Path\terraform"
[Environment]::SetEnvironmentVariable("Path", $envPath, "User")

Write-Host "Terraform v$Version installed successfully!"
Write-Host "Run 'Refresh your terminal' to use terraform command"