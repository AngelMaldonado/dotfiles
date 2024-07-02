<#
.SYNOPSIS
   Uninstalls Git and removes the symbolic link for the .gitconfig file.

.DESCRIPTION
    This script uninstalls Git using winget and removes the symbolic link for the .gitconfig file.

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
    $gitInstallDir = Join-Path -Path $PSScriptRoot -ChildPath "git"
} else {
    $gitInstallDir = $PSScriptRoot
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

# Function to remove a symbolic link or file
function Remove-SymbolicLink {
    param(
        [Parameter(Mandatory=$true)]
        [string]$LinkPath
    )

    if (Test-Path $LinkPath) {
        Remove-Item $LinkPath -Force
        Write-Log "Removed symbolic link or file at $LinkPath" -Color $Color_Success
    } else {
        Write-Log "Symbolic link or file at $LinkPath does not exist" -Color $Color_Warning
    }
}

# Define paths for symbolic link
$gitConfigTarget = "$env:USERPROFILE\.gitconfig"

# Remove symbolic link for .gitconfig
Remove-SymbolicLink -LinkPath $gitConfigTarget

# Uninstall Git
Uninstall-Package "Git.Git"

Write-Log "Git uninstallation completed." -Color $Color_Success
