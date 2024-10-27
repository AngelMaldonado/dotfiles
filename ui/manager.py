import sys
import termios
import tty
from ui.menu import Menu
from ui.renderer import Renderer


class UIManager:
    def __init__(self):
        self.renderer = Renderer()

    def run(self):
        # Create a menu
        menu_options = [
            {'label': 'Select Software', 'selected': False},
            {'label': 'Install All', 'selected': False},
            {'label': 'Remove Software', 'selected': False},
            {'label': 'Clean All', 'selected': False}
        ]
        menu = Menu(menu_options)

        # Add drawable elements to the handler
        self.renderer.add(menu)

        # Main loop for rendering and input handling
        while True:
            # Render the UI first
            self.renderer.render()

            # Get user input
            key = self.get_keypress()

            # Handle input for the menu
            menu.handle_input(key)

            # Quit on 'q' key
            if key == ord('q'):
                break

    def get_keypress(self):
        # Capture single keypress
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            key = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        return key
