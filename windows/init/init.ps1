# Author:   Angel Maldonado
# Created:  July-14-2023
# About:    This script creates environment variables for the Tools and Repos path.

Write-Host "Setting up environment variables...`n"
[System.Environment]::SetEnvironmentVariable("DevRepos", "C:/Dev/Repos", "User")
[System.Environment]::SetEnvironmentVariable("DevTools", "C:/Dev/Tools", "User")
