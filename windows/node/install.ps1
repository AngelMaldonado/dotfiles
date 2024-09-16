<#
.SYNOPSIS
   Installs Node.js LTS version.

.DESCRIPTION
    This script installs Node.js LTS using winget and can be extended to handle Node.js configuration files (if any) with symbolic links in the future.

.NOTES
    Author: Angel Maldonado
    Date: 2024-09-15
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
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [Parameter()]
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Determine the script execution path
if ($PSScriptRoot -like "*\windows") {
    $nodeInstallDir = Join-Path -Path $PSScriptRoot -ChildPath "node"
} else {
    $nodeInstallDir = $PSScriptRoot
}

# Function to install a package using winget
function Install-Package {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PackageName
    )

    $installedApps = winget list
    $packageInstalled = $installedApps -match $PackageName

    if ($packageInstalled) {
        Write-Log "$PackageName is already installed." -Color $Color_Success
    } else {
        Write-Log "Installing $PackageName..." -Color $Color_Warning

        try {
            winget install $PackageName -e
            Write-Log "$PackageName has been successfully installed." -Color $Color_Success
        } catch {
            Write-Log "Failed to install $PackageName." -Color $Color_Error
            Write-Log $_.Exception.Message -Color $Color_Error
        }
    }
}

# Install Node.js LTS
Install-Package "OpenJS.NodeJS.LTS"

Write-Log "Node.js LTS installation completed." -Color $Color_Success
