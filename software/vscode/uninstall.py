import os
import sys
import subprocess
from software import utils


def uninstall():
    """Uninstall VSCode depending on the OS."""
    platform_name = utils.get_platform()

    if platform_name == "windows":
        uninstall_vscode_windows()
    elif platform_name == "linux":
        uninstall_vscode_linux()
    elif platform_name == "macos":
        uninstall_vscode_macos()
    else:
        print(f"Unsupported platform: {platform_name}")


def uninstall_vscode_windows():
    """Uninstall Visual Studio Code on Windows using Chocolatey."""
    print("Uninstalling Visual Studio Code on Windows...")
    if not utils.check_command_exists("choco"):
        print("Chocolatey is not installed. Please install Chocolatey first.")
        sys.exit(1)

    # Start uninstallation in a non-blocking way
    subprocess.Popen(["choco", "uninstall", "vscode", "-y"],
                     stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print("VSCode uninstallation started on Windows. Returning to the interface...")
    remove_symlinks_windows()


def uninstall_vscode_linux():
    """Uninstall Visual Studio Code on Linux using apt."""
    print("Uninstalling Visual Studio Code on Linux...")
    if not utils.check_command_exists("apt-get"):
        print("apt-get is not available. Please ensure you're using a compatible Linux distribution.")
        sys.exit(1)

    # Start uninstallation in a non-blocking way
    subprocess.Popen(["sudo", "apt-get", "remove", "--purge", "code",
                     "-y"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print("VSCode uninstallation started on Linux. Returning to the interface...")
    remove_symlinks_linux()


def uninstall_vscode_macos():
    """Uninstall Visual Studio Code on macOS using Homebrew."""
    print("Uninstalling Visual Studio Code on macOS...")
    if not utils.check_command_exists("brew"):
        print("Homebrew is not installed. Please install Homebrew first.")
        sys.exit(1)

    # Start uninstallation in a non-blocking way
    subprocess.Popen(["brew", "uninstall", "visual-studio-code"],
                     stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print("VSCode uninstallation started on macOS. Returning to the interface...")
    remove_symlinks_macos()


def remove_symlinks_windows():
    """Remove symlinks for VSCode config files on Windows."""
    vscode_config_dir = os.path.join(os.getenv('APPDATA'), 'Code', 'User')
    remove_symlinks(vscode_config_dir)


def remove_symlinks_linux():
    """Remove symlinks for VSCode config files on Linux."""
    vscode_config_dir = os.path.join(
        os.getenv('HOME'), '.config', 'Code', 'User')
    remove_symlinks(vscode_config_dir)


def remove_symlinks_macos():
    """Remove symlinks for VSCode config files on macOS."""
    vscode_config_dir = os.path.join(
        os.getenv('HOME'), 'Library', 'Application Support', 'Code', 'User')
    remove_symlinks(vscode_config_dir)


def remove_symlinks(vscode_config_dir):
    """Remove symlinks for the VSCode configuration files."""
    try:
        settings_symlink = os.path.join(vscode_config_dir, 'settings.json')
        keybindings_symlink = os.path.join(
            vscode_config_dir, 'keybindings.json')

        # Remove symlink for settings.json if it exists
        if os.path.islink(settings_symlink):
            os.remove(settings_symlink)
            print("Removed symlink for settings.json")
        else:
            print("settings.json symlink does not exist, skipping removal.")

        # Remove symlink for keybindings.json if it exists
        if os.path.islink(keybindings_symlink):
            os.remove(keybindings_symlink)
            print("Removed symlink for keybindings.json")
        else:
            print("keybindings.json symlink does not exist, skipping removal.")

    except Exception as e:
        print(f"Error removing symlinks: {e}")


if __name__ == "__main__":
    uninstall()
