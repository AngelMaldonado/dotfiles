<#
.SYNOPSIS
   Installs Git and creates a symbolic link for the .gitconfig file.

.DESCRIPTION
    This script installs Git using winget and creates a symbolic link for the .gitconfig file to the default location.

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

# Function to create a symbolic link
function Create-SymbolicLink {
    param(
        [Parameter(Mandatory=$true)]
        [string]$LinkPath,
        [Parameter(Mandatory=$true)]
        [string]$TargetPath
    )

    if (Test-Path $LinkPath) {
        Remove-Item $LinkPath -Force
        Write-Log "Removed existing file or symlink at $LinkPath" -Color $Color_Warning
    }

    try {
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath
        Write-Log "Created symbolic link: $LinkPath -> $TargetPath" -Color $Color_Success
    } catch {
        Write-Log "Failed to create symbolic link: $LinkPath -> $TargetPath" -Color $Color_Error
        Write-Log $_.Exception.Message -Color $Color_Error
    }
}

# Install Git
Install-Package "Git.Git"

# Define paths for symbolic link
$gitConfigSource = Join-Path -Path $gitInstallDir -ChildPath ".gitconfig"
$gitConfigTarget = "$env:USERPROFILE\.gitconfig"

# Create symbolic link for .gitconfig
Create-SymbolicLink -LinkPath $gitConfigTarget -TargetPath $gitConfigSource

Write-Log "Git setup and installation completed." -Color $Color_Success
