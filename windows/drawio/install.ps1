<#
.SYNOPSIS
   Installs Draw.io (JGraph.Draw).

.DESCRIPTION
    This script installs Draw.io (JGraph.Draw) using winget.

.NOTES
    Author: Angel Maldonado
    Date: 2024-07-02
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

# Define installation directories
if ($PSScriptRoot -like "*\windows") {
    $drawioInstallDir = Join-Path -Path $PSScriptRoot -ChildPath "drawio"
} else {
    $drawioInstallDir = $PSScriptRoot
}

# Function to install a package using winget
function Install-Package {
    param(
        [Parameter(Mandatory=$true)]
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

# Install Draw.io (JGraph.Draw)
Install-Package "JGraph.Draw"

Write-Log "Draw.io setup and installation completed." -Color $Color_Success
