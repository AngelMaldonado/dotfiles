# Author:   Angel Maldonado
# Created:  January-30-2023
# About:    This script installs PowerShell, OhMyPosh and Windows Terminal
#           and creates a symlink for the Windows Terminal settings.json file
#           to the dotfiles repository.

Write-Host 'Installing PowerShell...'
winget install Microsoft.PowerShell

Write-Host 'Installing OhMyPosh...'
winget install JanDeDobbeleer.OhMyPosh

Write-Host 'Installing Windows Terminal...'
winget install Microsoft.WindowsTerminal

Write-Host 'Creating symlink for Windows Terminal settings...'
# Check if there is no settings.json file
if (Test-Path $env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json) {
    # If there is, delete it
    Remove-Item $env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
}
New-Item -ItemType SymbolicLink -Target $env:DevRepos/dotfiles/powershell/settings.json -Path $env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

Write-Host 'Creating symlink for PowerShell profile...'
# Check if there is no Microsoft.PowerShell_profile.ps1 file
if (Test-Path [Environment]::GetFolderPath("MyDocuments")/PowerShell/Microsoft.PowerShell_profile.ps1) {
    # If there is, delete it
    Remove-Item [Environment]::GetFolderPath("MyDocuments")/PowerShell/Microsoft.PowerShell_profile.ps1
}
New-Item -ItemType SymbolicLink -Target $env:DevRepos/dotfiles/powershell/Microsoft.PowerShell_profile.ps1 -Path [Environment]::GetFolderPath("MyDocuments")/PowerShell/Microsoft.PowerShell_profile.ps1

#Check if there is no Microsoft.VSCode_profile.ps1 file
if (Test-Path [Environment]::GetFolderPath("MyDocuments")/PowerShell/Microsoft.VSCode_profile.ps1) {
    # If there is, delete it
    Remove-Item [Environment]::GetFolderPath("MyDocuments")/PowerShell/Microsoft.VSCode_profile.ps1
}
New-Item -ItemType SymbolicLink -Target $env:DevRepos/dotfiles/powershell/Microsoft.VSCode_profile.ps1 -Path [Environment]::GetFolderPath("MyDocuments")/PowerShell/Microsoft.VSCode_profile.ps1