<#
.SYNOPSIS
   Installs Visual Studio Code using winget and sets up configuration files.

.DESCRIPTION
    This script installs Visual Studio Code using the winget package manager. If Visual Studio Code is already installed, it proceeds to create a symlink for settings.json to the default VS Code settings location, if not already linked.

.NOTES
    Author: Angel Maldonado
    Date: 2024-06-28
    Version: 1.2
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

# Function to create a symbolic link
function New-SymbolicLink {
    param(
        [Parameter(Mandatory=$true)]
        [string]$TargetPath,
        [Parameter(Mandatory=$true)]
        [string]$LinkPath
    )

    if (Test-Path $LinkPath) {
        Remove-Item $LinkPath -Force -Recurse
    }

    New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath | Out-Null
}

# Determine script execution path
if ($PSScriptRoot -like "*\windows") {
    # Executed from setup.ps1 in parent /windows folder
    $vscodeInstallDir = "$PSScriptRoot\vscode"
} else {
    # Executed directly from /vscode folder
    $vscodeInstallDir = "$PSScriptRoot"
}

# Function to install Visual Studio Code using winget
function Install-VisualStudioCode {
    # Check if Visual Studio Code is already installed
    $installedApps = winget list
    $vscodeInstalled = $installedApps -match "Microsoft.VisualStudioCode"

    if ($vscodeInstalled) {
        Write-Log "Visual Studio Code is already installed." -Color $Color_Success
    } else {
        # Attempt to install Visual Studio Code
        Write-Log "Installing Visual Studio Code..." -Color $Color_Warning

        try {
            winget install Microsoft.VisualStudioCode -e
            Write-Log "Visual Studio Code has been successfully installed." -Color $Color_Success
        } catch {
            Write-Log "Failed to install Visual Studio Code." -Color $Color_Error
            Write-Log $_.Exception.Message -Color $Color_Error
            return
        }
    }

    # Create symlink for settings.json
    $vscodeSettingsDir = "$env:APPDATA\Code\User"
    $settingsJsonLink = "$vscodeSettingsDir\settings.json"
    $keybindingsJsonLink = "$vscodeSettingsDir\keybindings.json"

    try {
        New-SymbolicLink -TargetPath "$vscodeInstallDir\settings.json" -LinkPath $settingsJsonLink
        New-SymbolicLink -TargetPath "$vscodeInstallDir\keybindings.json" -LinkPath $keybindingsJsonLink
        Write-Log "Symbolic link for settings.json created successfully." -Color $Color_Success
    } catch {
        Write-Log "Failed to create symbolic link for settings.json." -Color $Color_Error
        Write-Log $_.Exception.Message -Color $Color_Error
    }
}

# Main script execution
Write-Log "Starting installation of Visual Studio Code and setting up configuration." -Color $Color_Warning
Install-VisualStudioCode
