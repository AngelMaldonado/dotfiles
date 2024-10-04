<#
.SYNOPSIS
   Uninstalls Visual Studio Code and removes related configuration.

.DESCRIPTION
    This script removes any related configuration files and symlinks for Visual Studio Code, then uninstalls it using winget.

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

# Function to remove a symbolic link
function Remove-SymbolicLink {
    param(
        [Parameter(Mandatory=$true)]
        [string]$LinkPath
    )

    $linkItem = Get-Item $LinkPath -ErrorAction SilentlyContinue
    if ($linkItem -ne $null -and $linkItem.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        Remove-Item $LinkPath -Force
        Write-Log "Removed symbolic link: $LinkPath" -Color $Color_Success
    }
}

# Function to uninstall Visual Studio Code using winget
function Uninstall-VisualStudioCode {
    # Remove configuration files and symlinks
    $vscodeSettingsDir = "$env:APPDATA\Code\User"
    $settingsJsonLink = "$vscodeSettingsDir\settings.json"

    try {
        if (Test-Path $settingsJsonLink) {
            Remove-SymbolicLink -LinkPath $settingsJsonLink
        }

        # Optionally, remove other related configuration or data directories here if needed

    } catch {
        Write-Log "Failed to remove configuration files or symlinks." -Color $Color_Error
        Write-Log $_.Exception.Message -Color $Color_Error
    }

    # Check if Visual Studio Code is installed
    $installedApps = winget list
    $vscodeInstalled = $installedApps -match "Microsoft.VisualStudioCode"

    if (!$vscodeInstalled) {
        Write-Log "Visual Studio Code is not installed." -Color $Color_Success
        return
    }

    # Attempt to uninstall Visual Studio Code
    Write-Log "Uninstalling Visual Studio Code..." -Color $Color_Warning

    try {
        winget uninstall Microsoft.VisualStudioCode -e
        Write-Log "Visual Studio Code has been successfully uninstalled." -Color $Color_Success
    } catch {
        Write-Log "Failed to uninstall Visual Studio Code." -Color $Color_Error
        Write-Log $_.Exception.Message -Color $Color_Error
        return
    }
}

# Main script execution
Write-Log "Starting uninstallation of Visual Studio Code." -Color $Color_Warning
Uninstall-VisualStudioCode
