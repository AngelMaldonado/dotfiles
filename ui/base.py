class BaseUI:
    def __init__(self, stdscr):
        self.stdscr = stdscr

    def get_centered_position(self, text):
        """Helper to calculate the centered position for any given text."""
        height, width = self.stdscr.getmaxyx()
        x = width // 2 - len(text) // 2
        return x, height
