import os
import sys
import subprocess
from software import utils


def install():
    """Install VSCode depending on the OS."""
    platform_name = utils.get_platform()

    if platform_name == "windows":
        install_vscode_windows()
    elif platform_name == "linux":
        install_vscode_linux()
    elif platform_name == "macos":
        install_vscode_macos()
    else:
        print(f"Unsupported platform: {platform_name}")


def install_vscode_windows():
    """Install Visual Studio Code on Windows using Chocolatey."""
    print("Installing Visual Studio Code on Windows...")
    if not utils.check_command_exists("choco"):
        print("Chocolatey is not installed. Please install Chocolatey first.")
        sys.exit(1)

    # Start installation in a non-blocking way
    subprocess.Popen(["choco", "install", "vscode", "-y"],
                     stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print("VSCode installation started on Windows. Returning to the interface...")
    create_symlinks_windows()


def install_vscode_linux():
    """Install Visual Studio Code on Linux using apt."""
    print("Installing Visual Studio Code on Linux...")
    if not utils.check_command_exists("apt-get"):
        print("apt-get is not available. Please ensure you're using a compatible Linux distribution.")
        sys.exit(1)

    # Start installation in a non-blocking way
    commands = [
        "wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg",
        "sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/",
        "sudo sh -c 'echo \"deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main\" > /etc/apt/sources.list.d/vscode.list'",
        "sudo apt-get update && sudo apt-get install -y code"
    ]

    for command in commands:
        subprocess.Popen(command, stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE, shell=True)

    print("VSCode installation started on Linux. Returning to the interface...")
    create_symlinks_linux()


def install_vscode_macos():
    """Install Visual Studio Code on macOS using Homebrew."""
    print("Installing Visual Studio Code on macOS...")
    if not utils.check_command_exists("brew"):
        print("Homebrew is not installed. Please install Homebrew first.")
        sys.exit(1)

    # Start installation in a non-blocking way
    subprocess.Popen(["brew", "install", "visual-studio-code"],
                     stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print("VSCode installation started on macOS. Returning to the interface...")
    create_symlinks_macos()


def create_symlinks_windows():
    """Create symlinks for VSCode config files on Windows."""
    vscode_config_dir = os.path.join(os.getenv('APPDATA'), 'Code', 'User')
    create_symlinks(vscode_config_dir)


def create_symlinks_linux():
    """Create symlinks for VSCode config files on Linux."""
    vscode_config_dir = os.path.join(
        os.getenv('HOME'), '.config', 'Code', 'User')
    create_symlinks(vscode_config_dir)


def create_symlinks_macos():
    """Create symlinks for VSCode config files on macOS."""
    vscode_config_dir = os.path.join(
        os.getenv('HOME'), 'Library', 'Application Support', 'Code', 'User')
    create_symlinks(vscode_config_dir)


def create_symlinks(vscode_config_dir):
    """Create symlinks for the VSCode configuration files."""
    current_dir = os.path.dirname(__file__)
    settings_src = os.path.join(current_dir, 'settings.json')
    keybindings_src = os.path.join(current_dir, 'keybindings.json')

    try:
        # Delete existing settings.json if it exists
        existing_settings = os.path.join(vscode_config_dir, 'settings.json')
        if os.path.exists(existing_settings):
            os.remove(existing_settings)
            print("Removed existing settings.json")

        # Delete existing keybindings.json if it exists
        existing_keybindings = os.path.join(
            vscode_config_dir, 'keybindings.json')
        if os.path.exists(existing_keybindings):
            os.remove(existing_keybindings)
            print("Removed existing keybindings.json")

        # Create symlinks for settings.json
        os.symlink(settings_src, existing_settings)
        print("Created symlink for settings.json")

        # Create symlinks for keybindings.json
        os.symlink(keybindings_src, existing_keybindings)
        print("Created symlink for keybindings.json")

    except Exception as e:
        print(f"Error creating symlinks: {e}")
