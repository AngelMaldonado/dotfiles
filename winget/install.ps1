# Author:   Angel Maldonado
# Created:  May-08-2023
# About:    This script creates a symlink for the winget package manager.

# TODO: Add winget install script

# Configuring winget
Write-Output "Creating symlink for winget settings...`n"
# Creating config symlink
New-Item -ItemType SymbolicLink -Target $env:DevRepos/dotfiles/winget/settinge.json -Path $env:LOCALAPPDATA/Packages/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe/LocalState/settings.json
