<#
.SYNOPSIS
   Removes installed software from subdirectories.

.DESCRIPTION
    This script removes installed software from subdirectories using their respective uninstall.ps1 scripts found in each subdirectory.

.NOTES
    Author: Angel Maldonado
    Date: 2024-06-28
    Version: 1.0
    License: MIT
#>

# Constants for output colors
$Color_Success = "Green"
$Color_Error = "Red"
$Color_Warning = "Yellow"

# Function to display colored output
function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter()]
        [string]$Color = "White"
    )

    Write-Host $Message -ForegroundColor $Color
}

# Define subdirectories to uninstall from (folder names)
$subdirectories = @("vscode", "powershell")  # Add more as needed

# Iterate through each subdirectory and execute uninstall.ps1 if present
foreach ($subdir in $subdirectories) {
    $uninstallScript = Join-Path -Path $PSScriptRoot -ChildPath "$subdir\uninstall.ps1"

    if (Test-Path $uninstallScript) {
        Write-Log "Executing uninstallation for $subdir..." -Color $Color_Warning
        & $uninstallScript
    } else {
        Write-Log "Uninstall script for $subdir not found." -Color $Color_Error
    }
}
