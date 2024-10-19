from ui.welcome import Welcome
from ui.menu import Menu


class UIManager:
    def __init__(self, stdscr):
        self.stdscr = stdscr
        self.welcome = Welcome(stdscr)
        self.menu = Menu(stdscr)
        self.current_row = 0

    def display(self):
        """Handles rendering of all UI components (welcome, menu, instructions)."""
        self.stdscr.clear()

        # Display welcome message
        self.welcome.display()

        # Display menu options
        self.menu.display(self.current_row)

        # Display navigation instructions at the bottom
        height, width = self.stdscr.getmaxyx()
        instructions = "Use j/k to move, Enter to select, q to quit"
        self.stdscr.addstr(height - 2, width // 2 -
                           len(instructions) // 2, instructions)

        # Refresh the screen
        self.stdscr.refresh()

    def handle_keypress(self, key):
        """Handles keypress input for Vim-like navigation and quitting."""
        self.current_row = self.menu.handle_input(key, self.current_row)
        return self.menu.should_exit(key, self.current_row)
