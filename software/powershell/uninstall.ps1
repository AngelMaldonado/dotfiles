<#
.SYNOPSIS
   Uninstalls PowerShell 7, Windows Terminal, Oh My Posh, and Terminal-Icons. Removes configuration files and symlinks.

.DESCRIPTION
    This script uninstalls PowerShell 7, Windows Terminal, Oh My Posh, and Terminal-Icons. It also removes necessary symlinks and configuration files.

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

# Paths for symbolic links
$windowsTerminalSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$powershellProfile = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

# Remove symbolic links and configuration files
Remove-SymbolicLink -LinkPath $windowsTerminalSettings
Remove-SymbolicLink -LinkPath $powershellProfile

# Uninstall Terminal-Icons module
try {
    Uninstall-Module -Name Terminal-Icons -AllVersions -Force -ErrorAction Stop
    Write-Log "Terminal-Icons module has been successfully uninstalled." -Color $Color_Success
} catch {
    Write-Log "Failed to uninstall Terminal-Icons module or it was not installed." -Color $Color_Warning
    Write-Log $_.Exception.Message -Color $Color_Error
}

# Uninstall Oh My Posh
Uninstall-Package "JanDeDobbeleer.OhMyPosh"

# Uninstall Windows Terminal
Uninstall-Package "Microsoft.WindowsTerminal"

# Uninstall PowerShell 7
Uninstall-Package "Microsoft.PowerShell"

Write-Log "PowerShell uninstallation and cleanup completed." -Color $Color_Success
