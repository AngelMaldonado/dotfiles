from ui.components.menu import Menu
from ui.components.text import Text
from ui.renderer import Renderer


class UIManager:
    def __init__(self, stdscr):
        self.renderer = Renderer(stdscr)

    def run(self):
        # Create a menu
        menu_options = [
            {'label': 'Select Software', 'selected': False},
            {'label': 'Install All', 'selected': False},
            {'label': 'Remove Software', 'selected': False},
            {'label': 'Clean All', 'selected': False}
        ]
        menu = Menu(menu_options, x=10, y=5)

        # Create a welcome text
        welcome_text = Text("Welcome to the Developer Tool", x=10, y=3)

        # Add drawable elements to the handler
        self.renderer.add(welcome_text)
        self.renderer.add(menu)

        # Main loop for rendering and input handling
        while True:
            # Render the UI first
            self.renderer.render()

            # Get user input
            key = self.renderer.stdscr.getch()

            # Handle input for the menu
            menu.handle_input(key)

            # Render the UI again after input handling to reflect changes
            self.renderer.render()

            # Quit on 'q' key
            if key == ord('q'):
                break
