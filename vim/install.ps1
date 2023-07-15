# Author:   Angel Maldonado
# Created:  July-15-2023
# About:    This script creates symlinks for the .rc files for vim

Write-Host 'Creating symlink for .vimrc file...'
# Check if there is no .vimrc file
if (Test-Path $env:USERPROFILE/.vimrc) {
    # If there is, delete it
    Remove-Item $env:USERPROFILE/.vimrc
}
New-Item -ItemType SymbolicLink -Target $env:DevRepos/dotfiles/vim/.vimrc -Path $env:USERPROFILE/.vimrc

Write-Host 'Creating symlink for .ideavim file...'
# Check if there is no .ideavim file
if (Test-Path $env:USERPROFILE/.ideavimrc) {
    # If there is, delete it
    Remove-Item $env:USERPROFILE/.ideavimrc
}
New-Item -ItemType SymbolicLink -Target $env:DevRepos/dotfiles/vim/.ideavimrc -Path $env:USERPROFILE/.ideavimrc
