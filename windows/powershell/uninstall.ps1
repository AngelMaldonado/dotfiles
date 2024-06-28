<#
.SYNOPSIS
    Script to uninstall PowerShell, Windows Terminal, and Oh My Posh.

.DESCRIPTION
    This script uninstalls PowerShell, Windows Terminal, and Oh My Posh.
    It also removes symlinks for the settings.json file of Windows Terminal and
    the PowerShell profile, along with their parent directories.

.NOTES
    Author: Angel Maldonado
    Date: 2024-06-27
    Version: 1.0
    License: MIT

#>

# Enable strict mode
Set-StrictMode -Version Latest

# Function to display progress bar
function Show-ProgressBar {
    param (
        [int] $Progress,
        [int] $Total,
        [string] $Message
    )

    $ProgressBarWidth = 50
    $Completed = [math]::Round(($Progress / $Total) * $ProgressBarWidth)
    $Remaining = $ProgressBarWidth - $Completed
    $ProgressBar = '[' + ('=' * $Completed) + (' ' * $Remaining) + ']'
    
    Write-Progress -Activity $Message -Status $ProgressBar -PercentComplete (($Progress / $Total) * 100)
}

# Function to uninstall software using winget
function Uninstall-Software {
    param (
        [string]$Id,
        [string]$Name
    )

    try {
        $softwareInstalled = @(winget list -e | Where-Object { $_ -like "*$Id*" }).Count -gt 0

        if ($softwareInstalled) {
            Write-Host "Uninstalling $Name..."

            # Get total number of steps for progress tracking
            $totalSteps = 100
            $currentStep = 0

            # Uninstall software using winget
            winget uninstall --id $Id -e | ForEach-Object {
                $currentStep++
                $progressPercent = [math]::Round(($currentStep / $totalSteps) * 100)
                Show-ProgressBar -Progress $progressPercent -Total 100 -Message "Uninstalling $Name"
            }

            Write-Host "$Name has been uninstalled successfully."
        } else {
            Write-Host "$Name is not installed."
        }
    } catch {
        Write-Error "Failed to uninstall $Name"
        exit 1
    }
}

# Main script logic

try {
    # Uninstall PowerShell 7
    #Uninstall-Software -Id "Microsoft.PowerShell" -Name "PowerShell 7"

    # Uninstall Windows Terminal
    Uninstall-Software -Id "Microsoft.WindowsTerminal" -Name "Windows Terminal"

    # Uninstall Oh My Posh
    Uninstall-Software -Id "JanDeDobbeleer.OhMyPosh" -Name "Oh My Posh"

    # Define paths for settings.json and PowerShell profile
    $settingsJsonTarget = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    $profileTarget = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

    # Remove symlink for Windows Terminal settings.json and its parent directory if empty
    if (Test-Path -Path $settingsJsonTarget) {
        Remove-Item -Path $settingsJsonTarget -Force
        Write-Host "Symlink for Windows Terminal settings.json removed."
    }
    $settingsJsonParentDir = Split-Path -Parent $settingsJsonTarget
    if ((Get-ChildItem -Path $settingsJsonParentDir).Count -eq 0) {
        Remove-Item -Path $settingsJsonParentDir -Force
        Write-Host "Parent directory of settings.json removed."
    }

    # Remove symlink for PowerShell profile and its parent directory if empty
    if (Test-Path -Path $profileTarget) {
        Remove-Item -Path $profileTarget -Force
        Write-Host "Symlink for PowerShell profile removed."
    }
    $profileParentDir = Split-Path -Parent $profileTarget
    if ((Get-ChildItem -Path $profileParentDir).Count -eq 0) {
        Remove-Item -Path $profileParentDir -Force
        Write-Host "Parent directory of PowerShell profile removed."
    }

    Write-Host "Uninstallation process completed successfully."
} catch {
    Write-Error "Failed during uninstallation process: $_"
    exit 1
}
