import subprocess
import sys
import curses
from ui.manager import UIManager


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


def main(stdscr):
    # Initialize the UI Manager
    UIManager(stdscr).run()


if __name__ == "__main__":
    install_curses()
    curses.wrapper(main)
