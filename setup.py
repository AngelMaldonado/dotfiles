import os
import subprocess
import sys
import curses
from ui.manager import UIManager
from ui.welcome import Welcome
from ui.menu import Menu


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


def main(stdscr):
    # Initialize color pairs
    curses.start_color()
    curses.init_pair(1, curses.COLOR_BLACK, curses.COLOR_WHITE)

    # Initialize the UI Manager
    ui_manager = UIManager(stdscr)

    # Main application loop
    while True:
        # Display the UI (welcome, menu, instructions)
        ui_manager.display()

        # Capture user keypress
        key = stdscr.getch()

        # Handle keypress and quit if needed
        if ui_manager.handle_keypress(key):
            break


if __name__ == "__main__":
    install_curses()
    curses.wrapper(main)
