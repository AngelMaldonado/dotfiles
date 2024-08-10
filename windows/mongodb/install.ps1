<#
.SYNOPSIS
   Installs MongoDB.

.DESCRIPTION
    This script installs MongoDB using winget.

.NOTES
    Author: Angel Maldonado
    Date: 2024-08-07
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

# Define installation directories
if ($PSScriptRoot -like "*\windows") {
    $mongoInstallDir = Join-Path -Path $PSScriptRoot -ChildPath "mongodb"
}
else {
    $mongoInstallDir = $PSScriptRoot
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
    }
    else {
        Write-Log "Installing $PackageName..." -Color $Color_Warning

        try {
            winget install $PackageName -e
            Write-Log "$PackageName has been successfully installed." -Color $Color_Success
        }
        catch {
            Write-Log "Failed to install $PackageName." -Color $Color_Error
            Write-Log $_.Exception.Message -Color $Color_Error
        }
    }
}

# Install MongoDB
Install-Package "MongoDB.Server"
Install-Package "MongoDB.Compass.Community"
Install-Package "MongoDB.Shell"

Write-Log "MongoDB setup and installation completed." -Color $Color_Success
