<#
.SYNOPSIS
    Script to install and configure PowerShell7, Windows Terminal, and Oh My Posh.

.DESCRIPTION
    This script installs PowerShell7, Windows Terminal, and Oh My Posh using winget,
    then creates symlinks for the Windows Terminal settings.json file and the PowerShell profile.

.NOTES
    Author: Angel Maldonado
    Date: 2024-06-26
    Version: 1.0
    License: MIT

#>

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

# Install PowerShell7
$pwshInstalled = @(winget list -e | Where-Object { $_ -like '*Microsoft.Powershell*' }).Count -gt 0
if (-not $pwshInstalled) {
    Write-Host "PowerShell7 is not installed. Installing now..."
    winget install --id Microsoft.Powershell --source winget | ForEach-Object {
        $Progress++
        Show-ProgressBar -Progress $Progress -Total $Total -Message "Installing PowerShell7"
    }
    Write-Host "PowerShell7 has been installed successfully."
} else {
    Write-Host "PowerShell7 is already installed."
}

# Install Windows Terminal
$terminalInstalled = @(winget list -e | Where-Object { $_ -like '*Microsoft.WindowsTerminal*' }).Count -gt 0
if (-not $terminalInstalled) {
    Write-Host "Windows Terminal is not installed. Installing now..."
    winget install -e --id Microsoft.WindowsTerminal | ForEach-Object {
        $Progress++
        Show-ProgressBar -Progress $Progress -Total $Total -Message "Installing Windows Terminal"
    }
    Write-Host "Windows Terminal has been installed successfully."
} else {
    Write-Host "Windows Terminal is already installed."
}

# Install Oh My Posh
$ohMyPoshInstalled = @(winget list -e | Where-Object { $_ -like '*JanDeDobbeleer.OhMyPosh*' }).Count -gt 0
if (-not $ohMyPoshInstalled) {
    Write-Host "Oh My Posh is not installed. Installing now..."
    winget install JanDeDobbeleer.OhMyPosh -s winget | ForEach-Object {
        $Progress++
        Show-ProgressBar -Progress $Progress -Total $Total -Message "Installing Oh My Posh"
    }
    Write-Host "Oh My Posh has been installed successfully."
} else {
    Write-Host "Oh My Posh is already installed."
}

# Install Termina-Icons module
Install-Module -Name Terminal-Icons -Repository PSGallery

# Create symlink for Windows Terminal settings.json
$sourceSettings = "$PSScriptRoot\settings.json"
$targetSettings = [System.IO.Path]::Combine($env:LOCALAPPDATA, "Packages", "Microsoft.WindowsTerminal_8wekyb3d8bbwe", "LocalState", "settings.json")
if (Test-Path $targetSettings) {
    Remove-Item $targetSettings -Force
}
New-Item -ItemType SymbolicLink -Path $targetSettings -Target $sourceSettings
Write-Host "Symlink for settings.json created successfully."

# Create symlink for PowerShell profile
$sourceProfile = "$PSScriptRoot\Microsoft.PowerShell_profile.ps1"
$targetProfile = [System.IO.Path]::Combine($env:USERPROFILE, "Documents", "PowerShell", "Microsoft.PowerShell_profile.ps1")
if (Test-Path $targetProfile) {
    Remove-Item $targetProfile -Force
}
New-Item -ItemType SymbolicLink -Path $targetProfile -Target $sourceProfile
Write-Host "Symlink for PowerShell profile created successfully."
