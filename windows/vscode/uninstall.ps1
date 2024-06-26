<#
.SYNOPSIS
    Script to uninstall Visual Studio Code.

.DESCRIPTION
    This script uninstall Visual Studio Code and removes symlink for
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

if ($vscodeInstalled) {
    Write-Host "Uninstalling Visual Studio Code..."

    # Uninstall Visual Studio Code using winget
    winget uninstall --id Microsoft.VisualStudioCode -e | ForEach-Object {
        # Display progress bar during uninstallation
        $Progress++
        Show-ProgressBar -Progress $Progress -Total $Total -Message "Uninstalling Visual Studio Code"
    }

    Write-Host "Visual Studio Code has been uninstalled successfully."
} else {
    Write-Host "Visual Studio Code is not installed."
}

#New-Item -ItemType SymbolicLink -Target $env:DevRepos/dotfiles/vscode/settings.json -Path $env:APPDATA/Code/User/settings.json