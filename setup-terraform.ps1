# Terraform Global Installation Setup Script
# Run this once to add Terraform to your system PATH permanently

$terraformPath = "C:\ProgramData\terraform"
$basePath = "D:\DevOps-Projects"

# Get current PATH values
$envPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Combine for current session
$combinedPath = $envPath + ";" + $userPath

# Append terraform if not already present
if ($combinedPath -notlike "*$terraformPath*") {
    [Environment]::SetEnvironmentVariable("Path", $combinedPath + ";$terraformPath", "User")
    Write-Host "Terraform PATH added to user environment variables"
}

# Create registry key for system PATH (requires admin context when executed)
$registryPath = "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment"
$registryKey = [Microsoft.Win32.Registry]::OpenRegistryBaseKey([Microsoft.Win32.Registry]::LocalMachine, "System\CurrentControlSet\Control\Session Manager\Environment", [Microsoft.Win32.RegistryRights]::ReadWrite)

if ($envPath -notlike "*$terraformPath*") {
    try {
        $registryKey.SetValue("Path", "$envPath;$userPath;$terraformPath", [Microsoft.Win32.RegistryValueKind]::ExpandString)
        Write-Host "Terraform PATH added to system registry"
    } catch {
        Write-Host "Could not add to system registry (requires admin rights or group policy)" -ForegroundColor Yellow
    }
    $registryKey.Close()
}

# Create a batch file to run for adding PATH
$batContent = "@echo off`r`nset PATH=%PATH%;C:\\ProgramData\\terraform`r`n"
Set-Content -Path "$basePath\add-terraform-to-path.bat" -Value $batContent -Encoding ASCII
Write-Host "Created: $basePath\add-terraform-to-path.bat"

# Close bash shell PATH
Write-Host "`n========================================"
Write-Host "Terraform is now globally installed!"
Write-Host "========================================"
Write-Host "`nTo use Terraform in a new terminal, run:"
Write-Host "  1. Restart your terminal (CMD/PowerShell)"
Write-Host "  2. Run: add-terraform-to-path.bat"
Write-Host "     OR run: Terraform"
Write-Host ""
Write-Host "Or add this to your profile:"
Write-Host '  echo "C:\\ProgramData\\terraform" >> $PROFILE'
