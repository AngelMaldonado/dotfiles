<#
.SYNOPSIS
   Uninstalls MongoDB.

.DESCRIPTION
    This script uninstalls MongoDB using winget.

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

# Function to uninstall a package using winget
function Uninstall-Package {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PackageName
    )

    $installedApps = winget list
    $packageInstalled = $installedApps -match $PackageName

    if ($packageInstalled) {
        Write-Log "Uninstalling $PackageName..." -Color $Color_Warning

        try {
            winget uninstall $PackageName -e
            Write-Log "$PackageName has been successfully uninstalled." -Color $Color_Success
        }
        catch {
            Write-Log "Failed to uninstall $PackageName." -Color $Color_Error
            Write-Log $_.Exception.Message -Color $Color_Error
        }
    }
    else {
        Write-Log "$PackageName is not installed." -Color $Color_Success
    }
}

# Uninstall MongoDB
Uninstall-Package "MongoDB.Server"
Uninstall-Package "MongoDB.Compass.Community"

Write-Log "MongoDB uninstallation completed." -Color $Color_Success
