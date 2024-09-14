<#
.SYNOPSIS
   Installs Neovim.

.DESCRIPTION
    This script installs Neovim using winget and sets up any necessary configurations.

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

# Install Neovim
Install-Package "Neovim.Neovim"
# Install fd
Install-Package "sharkdp.fd"
# Install zig
Install-Package "zig.zig"
# Install ripgrep
Install-Package "BurntSushi.ripgrep.GNU"
# Install sharkdp-fd
Install-Package "sharkdp.fd"

# Symlink creation for the entire nvim folder
$nvimSourceDir = Join-Path -Path $neovimInstallDir -ChildPath "nvim"
$nvimTargetDir = "$HOME\AppData\Local\nvim"

# Remove the target directory if it already exists
if (Test-Path $nvimTargetDir) {
    Write-Log "Removing existing Neovim configuration directory..." -Color $Color_Warning
    Remove-Item -Path $nvimTargetDir -Recurse -Force
}

# Create the symlink for the nvim folder
Write-Log "Creating symlink for the entire nvim folder..." -Color $Color_Warning
try {
    New-Item -ItemType SymbolicLink -Path $nvimTargetDir -Target $nvimSourceDir
    Write-Log "Symlink created for the nvim folder." -Color $Color_Success
} catch {
    Write-Log "Failed to create symlink for the nvim folder." -Color $Color_Error
    Write-Log $_.Exception.Message -Color $Color_Error
}

Write-Log "Neovim with LazyVim setup and installation completed." -Color $Color_Success