<#
.SYNOPSIS
   Installs PowerShell 7, Windows Terminal, Oh My Posh, and Terminal-Icons. Configures settings.

.DESCRIPTION
    This script installs PowerShell 7, Windows Terminal, Oh My Posh, and Terminal-Icons. It also creates necessary symlinks for configuration files.

.NOTES
    Author: Angel Maldonado
    Date: 2024-06-28
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
    $powershellInstallDir = Join-Path -Path $PSScriptRoot -ChildPath "powershell"
} else {
    $powershellInstallDir = $PSScriptRoot
}

# Function to create a symbolic link
function Create-SymbolicLink {
    param(
        [Parameter(Mandatory=$true)]
        [string]$TargetPath,
        [Parameter(Mandatory=$true)]
        [string]$LinkPath
    )

    if (Test-Path $LinkPath) {
        Remove-Item $LinkPath -Force
    }

    New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath
    Write-Log "Created symbolic link from $LinkPath to $TargetPath" -Color $Color_Success
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

# Install PowerShell 7
Install-Package "Microsoft.PowerShell"

# Install Windows Terminal
Install-Package "Microsoft.WindowsTerminal"

# Install Oh My Posh
Install-Package "JanDeDobbeleer.OhMyPosh"

# Install Terminal-Icons module
try {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -ErrorAction Stop
    Write-Log "Terminal-Icons module has been successfully installed." -Color $Color_Success
} catch {
    Write-Log "Failed to install Terminal-Icons module." -Color $Color_Error
    Write-Log $_.Exception.Message -Color $Color_Error
}

# Create symlinks for settings
$windowsTerminalSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$powershellProfile = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

# Ensure the PowerShell profile directory exists
$profileDirectory = [System.IO.Path]::GetDirectoryName($powershellProfile)
if (!(Test-Path -Path $profileDirectory)) {
    New-Item -ItemType Directory -Path $profileDirectory -Force
}

# Validate execution directory and set correct paths
if ($PSScriptRoot -like "*\windows") {
    $settingsJsonPath = Join-Path -Path $powershellInstallDir -ChildPath "settings.json"
    $profilePs1Path = Join-Path -Path $powershellInstallDir -ChildPath "Microsoft.PowerShell_profile.ps1"
} else {
    $settingsJsonPath = Join-Path -Path $PSScriptRoot -ChildPath "settings.json"
    $profilePs1Path = Join-Path -Path $PSScriptRoot -ChildPath "Microsoft.PowerShell_profile.ps1"
}

Create-SymbolicLink -TargetPath $settingsJsonPath -LinkPath $windowsTerminalSettings
Create-SymbolicLink -TargetPath $profilePs1Path -LinkPath $powershellProfile

Write-Log "PowerShell setup and configuration completed." -Color $Color_Success
