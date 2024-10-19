import curses
from ui.colors import ColorChannels
from ui.drawable import Drawable


class Renderer:
    def __init__(self, stdscr):
        self.stdscr = stdscr
        self.drawables = []
        curses.curs_set(0)
        ColorChannels.initialize_colors()

    def add(self, drawable):
        """Add a drawable element to be rendered."""
        if isinstance(drawable, Drawable):
            self.drawables.append(drawable)
        else:
            raise ValueError(
                "Drawable object must be an instance of Drawable class.")

    def render(self):
        """Render all drawable elements."""
        self.stdscr.clear()
        for drawable in self.drawables:
            drawable.draw(self.stdscr)
        self.stdscr.refresh()

    def clear(self):
        """Clear the list of drawables."""
        self.drawables.clear()
