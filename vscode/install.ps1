# Author:   Angel Maldonado
# Created:  July-14-2023
# About:    This script installs Visual Studio Code, and creates a symlink
#           for the VSCode settings.json file to the dotfiles repository.

Write-Host 'Installing Visual Studio Code...'
winget install -e --id Microsoft.VisualStudioCode

Write-Host 'Creating symlink for VS Code settings...'
# Check if there is no settings.json file
if (Test-Path $env:APPDATA/Code/User/settings.json) {
    # If there is, delete it
    Remove-Item $env:APPDATA/Code/User/settings.json
}
New-Item -ItemType SymbolicLink -Target $env:DevRepos/dotfiles/vscode/settings.json -Path $env:APPDATA/Code/User/settings.json