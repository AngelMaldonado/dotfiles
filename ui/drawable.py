from abc import ABC, abstractmethod


class Drawable(ABC):
    @abstractmethod
    def draw(self, stdscr):
        """Method to render the object on the screen."""
        pass
