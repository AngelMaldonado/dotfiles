<#
.SYNOPSIS
    Script to install software in the dotfiles directory.

.DESCRIPTION
    This script iterates through each subdirectory in the dotfiles directory
    and executes any install.ps1 scripts found within those directories.

.NOTES
    Author: Angel Maldonado
    Date: 2024-06-26
    Version: 1.0
    License: MIT

#>

# Enable strict mode
Set-StrictMode -Version Latest

# Define the base directory where the install scripts are located
$baseDir = "$PSScriptRoot"

# Define variables for each subdirectory
$vsCodeDir = Join-Path -Path $baseDir -ChildPath "vscode"
$gitDir = Join-Path -Path $baseDir -ChildPath "git"
$nodeDir = Join-Path -Path $baseDir -ChildPath "node"
# Add more directories as needed

# List of directories to process (comment out to skip)
$directoriesToProcess = @(
    $vsCodeDir,
    $gitDir,
    $nodeDir
    # Add or comment out directories as needed
)

# Function to execute install.ps1 in each specified directory
function Install-AllSoftware {
    param (
        [string[]]$Directories
    )
    
    foreach ($dir in $Directories) {
        $installScript = Join-Path -Path $dir -ChildPath "install.ps1"
        
        if (Test-Path -Path $installScript) {
            Write-Host "Executing $installScript in $($dir)..."
            try {
                & $installScript
                Write-Host "Successfully executed $installScript"
            } catch {
                Write-Error "Failed to execute $installScript"
            }
        } else {
            Write-Warning "No install.ps1 script found in $($dir). Skipping..."
        }
    }
}

# Main script logic
Write-Host "Starting installation of all selected software..."

Install-AllSoftware -Directories $directoriesToProcess

Write-Host "All selected installations completed."
