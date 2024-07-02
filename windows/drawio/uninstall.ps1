<#
.SYNOPSIS
   Uninstalls Draw.io (JGraph.Draw).

.DESCRIPTION
    This script uninstalls Draw.io (JGraph.Draw) using winget.

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

# Function to uninstall a package using winget
function Uninstall-Package {
    param(
        [Parameter(Mandatory=$true)]
        [string]$PackageName
    )

    $installedApps = winget list
    $packageInstalled = $installedApps -match $PackageName

    if ($packageInstalled) {
        Write-Log "Uninstalling $PackageName..." -Color $Color_Warning

        try {
            winget uninstall $PackageName -e
            Write-Log "$PackageName has been successfully uninstalled." -Color $Color_Success
        } catch {
            Write-Log "Failed to uninstall $PackageName." -Color $Color_Error
            Write-Log $_.Exception.Message -Color $Color_Error
        }
    } else {
        Write-Log "$PackageName is not installed." -Color $Color_Success
    }
}

# Uninstall Draw.io (JGraph.Draw)
Uninstall-Package "JGraph.Draw"

Write-Log "Draw.io uninstallation completed." -Color $Color_Success
