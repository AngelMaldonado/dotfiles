<#
.SYNOPSIS
    Script to uninstall software in the dotfiles/windows directory.

.DESCRIPTION
    This script iterates through each subdirectory in the dotfiles/windows directory
    and executes any uninstall.ps1 scripts found within those directories.

.NOTES
    Author: Angel Maldonado
    Date: 2024-06-26
    Version: 1.1
    License: MIT

#>

# Enable strict mode
Set-StrictMode -Version Latest

# Define the base directory where the uninstall scripts are located
$baseDir = "$PSScriptRoot"

# Define variables for each subdirectory
$vsCodeDir = Join-Path -Path $baseDir -ChildPath "vscode"
# Add more directories as needed

# List of directories to process (comment out to skip)
$directoriesToProcess = @(
    $vsCodeDir
    # Add or comment out directories as needed
)

# Function to execute uninstall.ps1 in each specified directory
function Uninstall-AllSoftware {
    param (
        [string[]]$Directories
    )
    
    foreach ($dir in $Directories) {
        $uninstallScript = Join-Path -Path $dir -ChildPath "uninstall.ps1"
        
        if (Test-Path -Path $uninstallScript) {
            Write-Host "Executing $uninstallScript in $($dir)..."
            try {
                & $uninstallScript
                Write-Host "Successfully executed $uninstallScript"
            } catch {
                Write-Error "Failed to execute $uninstallScript"
            }
        } else {
            Write-Warning "No uninstall.ps1 script found in $($dir). Skipping..."
        }
    }
}

# Main script logic
Write-Host "Starting uninstallation of all selected software..."

try {
    Uninstall-AllSoftware -Directories $directoriesToProcess
} catch {
    Write-Error "An error occurred during uninstallation: $_"
}

Write-Host "Uninstallation process completed."
