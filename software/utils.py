import platform
import subprocess


def get_platform():
    """Returns the name of the operating system."""
    current_platform = platform.system().lower()
    if current_platform.startswith("win"):
        return "windows"
    elif current_platform.startswith("linux"):
        return "linux"
    elif current_platform.startswith("darwin"):
        return "macos"
    else:
        raise OSError(f"Unsupported platform: {current_platform}")


def run_command(command, check=True):
    """Runs a shell command and returns the output, raises an error if fails."""
    try:
        result = subprocess.run(
            command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, text=True)
        if check and result.returncode != 0:
            raise subprocess.CalledProcessError(
                result.returncode, command, result.stderr)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e.cmd}\nReturn Code: {
              e.returncode}\nError: {e.output}")
        raise


def check_command_exists(command):
    """Check if a command exists on the system."""
    try:
        if get_platform() == "windows":
            result = subprocess.run(
                f"where {command}", stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        else:
            result = subprocess.run(
                f"command -v {command}", stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        return result.returncode == 0
    except Exception as e:
        print(f"Error checking if command exists: {e}")
        return False


def install_with_package_manager(package_name, package_manager):
    """Install a package using the appropriate package manager."""
    try:
        if package_manager == "apt":
            run_command(
                f"sudo apt-get update && sudo apt-get install -y {package_name}")
        elif package_manager == "brew":
            run_command(f"brew install {package_name}")
        elif package_manager == "choco":
            run_command(f"choco install {package_name} -y")
        else:
            raise ValueError(f"Unknown package manager: {package_manager}")
    except Exception as e:
        print(f"Failed to install {package_name}: {e}")


def detect_package_manager():
    """Detect the appropriate package manager based on the OS."""
    platform_name = get_platform()

    if platform_name == "linux":
        if check_command_exists("apt-get"):
            return "apt"
        else:
            raise EnvironmentError(
                "No supported package manager found (requires apt).")
    elif platform_name == "macos":
        if check_command_exists("brew"):
            return "brew"
        else:
            raise EnvironmentError(
                "No supported package manager found (requires Homebrew).")
    elif platform_name == "windows":
        if check_command_exists("choco"):
            return "choco"
        else:
            raise EnvironmentError(
                "No supported package manager found (requires Chocolatey).")
    else:
        raise OSError(f"Unsupported platform: {platform_name}")
