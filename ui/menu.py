import curses
from .base import BaseUI


class Menu(BaseUI):
    def __init__(self, stdscr):
        super().__init__(stdscr)
        self.menu = ['Option 1', 'Option 2', 'Option 3', 'Quit']

    def display(self, selected_row_idx):
        height, width = self.stdscr.getmaxyx()

        for idx, row in enumerate(self.menu):
            x = width // 2 - len(row) // 2
            y = height // 2 - len(self.menu) // 2 + idx
            if idx == selected_row_idx:
                self.stdscr.attron(curses.color_pair(1))
                self.stdscr.addstr(y, x, row)
                self.stdscr.attroff(curses.color_pair(1))
            else:
                self.stdscr.addstr(y, x, row)

        self.stdscr.refresh()

    def handle_input(self, key, current_row):
        if key == ord('j') and current_row < len(self.menu) - 1:
            return current_row + 1
        elif key == ord('k') and current_row > 0:
            return current_row - 1
        return current_row

    def should_exit(self, key, current_row):
        if key == ord('q') or (key == ord('\n') and current_row == len(self.menu) - 1):
            return True
        return False
