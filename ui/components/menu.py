import curses
from ui.colors import ColorChannels
from ui.components.text import Text
from ui.drawable import Drawable

from ui.components.text import Text
from ui.colors import ColorChannels


class Menu(Drawable):
    def __init__(self, options, x, y):
        self.options = options
        self.x = x
        self.y = y
        self.current_idx = 0
        self.text_elements = []

        # Create a list of Text objects for each option
        for idx, option in enumerate(self.options):
            color = ColorChannels.NORMAL_TEXT if idx != self.current_idx else ColorChannels.SELECTED_TEXT
            text = Text(f"{option['label']}", self.x, self.y + idx, color)
            self.text_elements.append(text)

    def draw(self, stdscr):
        """Draws the menu options to the screen."""
        for idx, option in enumerate(self.options):
            if idx == self.current_idx:
                self.text_elements[idx].set_color(ColorChannels.SELECTED_TEXT)
                self.text_elements[idx].set_text(option['label'])
            else:
                self.text_elements[idx].set_color(ColorChannels.NORMAL_TEXT)
                self.text_elements[idx].set_text(option['label'])

            # Draw the text
            self.text_elements[idx].draw(stdscr)

    def handle_input(self, key):
        """Handles user input and updates the selected index."""
        if key == ord('j') and self.current_idx < len(self.options) - 1:
            self.current_idx += 1
        elif key == ord('k') and self.current_idx > 0:
            self.current_idx -= 1

        # Update the text elements after handling input
        for idx in range(len(self.options)):
            color = ColorChannels.SELECTED_TEXT if idx == self.current_idx else ColorChannels.NORMAL_TEXT
            self.text_elements[idx].set_color(color)
