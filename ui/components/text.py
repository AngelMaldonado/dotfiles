import curses
from ui.colors import ColorChannels
from ui.drawable import Drawable


class Text(Drawable):
    def __init__(self, content, x, y, color_pair=ColorChannels.NORMAL_TEXT):
        self.content = content
        self.x = x
        self.y = y
        self.color_pair = color_pair

    def draw(self, stdscr):
        stdscr.attron(curses.color_pair(self.color_pair))
        stdscr.addstr(self.y, self.x, self.content)
        stdscr.attroff(curses.color_pair(self.color_pair))

    def set_color(self, color_pair):
        self.color_pair = color_pair

    def set_text(self, content):
        self.content = content
