import os
from ui.drawable import Drawable


class Renderer:
    def __init__(self):
        self.drawables = []

    def add(self, drawable):
        """Add a drawable element to be rendered."""
        if isinstance(drawable, Drawable):
            self.drawables.append(drawable)
        else:
            raise ValueError(
                "Drawable object must be an instance of Drawable class.")

    def clear_screen(self):
        os.system('cls' if os.name == 'nt' else 'clear')

    def render(self):
        """Render all drawable elements."""
        self.clear_screen()
        for drawable in self.drawables:
            drawable.draw()

    def clear(self):
        """Clear the list of drawables."""
        self.drawables.clear()
