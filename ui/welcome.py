import curses
from .base import BaseUI


class Welcome(BaseUI):
    def display(self):
        welcome_msg = "Welcome to the Dev Tool Installer"
        x_welcome, height = self.get_centered_position(welcome_msg)
        self.stdscr.addstr(2, x_welcome, welcome_msg, curses.A_BOLD)
