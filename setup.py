import os
import importlib
import subprocess
import sys
import signal
import curses


def install_curses():
    """Install the curses library based on the current platform."""
    try:
        if sys.platform.startswith('win'):
            subprocess.check_call(
                [sys.executable, '-m', 'pip', 'install', 'windows-curses'])
        else:
            print(
                "Curses library is typically included with Python on Unix-like systems.")
    except Exception as e:
        print(f"Failed to install curses library: {e}")


def get_available_software():
    """Retrieve the list of all available software based on folder names in the 'software' directory."""
    software_dir = os.path.join(os.path.dirname(__file__), 'software')
    return [name for name in os.listdir(software_dir) if os.path.isdir(os.path.join(software_dir, name))]


def install_software(software_name):
    """Install and configure the selected software."""
    try:
        module = importlib.import_module(f'software.{software_name}.install')
        if hasattr(module, 'install') and callable(module.install):
            module.install()
        else:
            print(f"No valid install function found for {software_name}.")
    except ModuleNotFoundError:
        print(f"Error: Could not find installation script for {
              software_name}.")


def handle_sigint(signum, frame):
    """Signal handler for Ctrl+C (SIGINT)."""
    print("\nCtrl+C detected! Exiting gracefully...")
    curses.endwin()  # Ensure curses exits cleanly
    sys.exit(0)  # Exit the program cleanly


def main(stdscr):
    """Main function to handle user interface and software installation."""
    signal.signal(signal.SIGINT, handle_sigint)

    curses.curs_set(0)  # Hide the cursor
    stdscr.clear()

    # Define color pairs for selected and unselected items
    curses.start_color()
    # Selected item color
    curses.init_pair(1, curses.COLOR_GREEN, curses.COLOR_WHITE)
    # Unselected item color
    curses.init_pair(2, curses.COLOR_WHITE, curses.COLOR_BLACK)

    available_software = get_available_software()
    available_software.insert(0, "All")  # Add "All" option at the beginning
    selected_software = [False] * len(available_software)
    current_row = 0

    while True:
        stdscr.clear()
        stdscr.addstr(
            0, 0, "Mark the software you want to install/configure (press 'i' to toggle selection, 'Enter' to start installation, 'q' to quit):")

        for idx, software in enumerate(available_software):
            mark = "[X]" if selected_software[idx] else "[ ]"
            if idx == current_row:
                # Highlight selected row
                stdscr.addstr(
                    idx + 1, 0, f"{mark} {software}", curses.color_pair(1))
            else:
                # Normal color for unselected rows
                stdscr.addstr(
                    idx + 1, 0, f"{mark} {software}", curses.color_pair(2))

        stdscr.refresh()

        key = stdscr.getch()

        if key == ord('k') and current_row > 0:  # Up key changed to 'k'
            current_row -= 1
        # Down key changed to 'j'
        elif key == ord('j') and current_row < len(available_software) - 1:
            current_row += 1
        elif key == ord('i'):
            # Toggle selection
            selected_software[current_row] = not selected_software[current_row]

            # If "All" is selected, toggle all other selections accordingly
            if current_row == 0:  # If "All" is selected/deselected
                for i in range(1, len(selected_software)):
                    selected_software[i] = selected_software[0]
        elif key in [curses.KEY_ENTER, 10, 13]:  # Enter key
            break
        elif key == ord('q'):
            return

    # Exit curses before proceeding with installations
    curses.endwin()

    # Gather selected software for installation
    for idx, selected in enumerate(selected_software):
        if selected and idx > 0:  # Skip "All" option in installation
            print(f"Installing {available_software[idx]}...")
            install_software(available_software[idx])
            print(f"{available_software[idx]} installation complete.")


if __name__ == "__main__":
    install_curses()  # Ensure curses is installed for the current platform
    curses.wrapper(main)
