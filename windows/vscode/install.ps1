<#
.SYNOPSIS
    Script to install Visual Studio Code.

.DESCRIPTION
    This script installs Visual Studio Code and creates symlink for
    the settings.json file.

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

# Check if Visual Studio Code is installed
$vscodeInstalled = @(winget list -e | Where-Object { $_ -like '*Microsoft.VisualStudioCode*' }).Count -gt 0

if (-not $vscodeInstalled) {
    Write-Host "Visual Studio Code is not installed. Installing now..."

    # Install Visual Studio Code using winget
    winget install --id Microsoft.VisualStudioCode -e | ForEach-Object {
        # Display progress bar during installation
        $Progress++
        Show-ProgressBar -Progress $Progress -Total $Total -Message "Installing Visual Studio Code"
    }

    Write-Host "Visual Studio Code has been installed successfully."
} else {
    Write-Host "Visual Studio Code is already installed."
}

#New-Item -ItemType SymbolicLink -Target $env:DevRepos/dotfiles/vscode/settings.json -Path $env:APPDATA/Code/User/settings.json