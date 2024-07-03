<#
.SYNOPSIS
   Sets up environment and installs software from subdirectories.

.DESCRIPTION
    This script sets up the environment and installs software from subdirectories using their respective install.ps1 scripts found in each subdirectory.

.NOTES
    Author: Angel Maldonado
    Date: 2024-06-28
    Version: 2.0
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

# Define subdirectories to install from (folder names)
$subdirectories = @("vscode", "powershell", "git")  # Add more as needed

# Iterate through each subdirectory and execute install.ps1 if present
foreach ($subdir in $subdirectories) {
    $installScript = Join-Path -Path $PSScriptRoot -ChildPath "$subdir\install.ps1"

    if (Test-Path $installScript) {
        Write-Log "Executing setup for $subdir..." -Color $Color_Warning
        & $installScript
    } else {
        Write-Log "Install script for $subdir not found." -Color $Color_Error
    }
}
