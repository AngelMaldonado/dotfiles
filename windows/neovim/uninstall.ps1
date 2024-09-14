<#
.SYNOPSIS
   Uninstalls Neovim.

.DESCRIPTION
    This script uninstalls Neovim using winget and removes any related configuration files.

.NOTES
    Author: Angel Maldonado
    Date: 2024-09-01
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
    $neovimInstallDir = Join-Path -Path $PSScriptRoot -ChildPath "neovim"
}
else {
    $neovimInstallDir = $PSScriptRoot
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

# Remove Neovim configuration symlink if it exists
$neovimConfigPath = "$HOME\AppData\Local\nvim\init.vim"

if (Test-Path $neovimConfigPath) {
    Write-Log "Removing Neovim configuration symlink..." -Color $Color_Warning
    try {
        Remove-Item $neovimConfigPath -Force
        Write-Log "Neovim configuration symlink removed." -Color $Color_Success
    }
    catch {
        Write-Log "Failed to remove Neovim configuration symlink." -Color $Color_Error
        Write-Log $_.Exception.Message -Color $Color_Error
    }
}

# Uninstall Neovim
Uninstall-Package "Neovim.Neovim"

Write-Log "Neovim uninstallation completed." -Color $Color_Success
