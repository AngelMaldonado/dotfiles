import os
import curses
from .base import BaseUI


class Menu(BaseUI):
    def __init__(self, stdscr):
        super().__init__(stdscr)
        self.menu = [
            "Select Software",
            "Install All",
            "Remove Software",
            "Clean All",
            "Update Software",
            "View Installed Software"
        ]
        self.software_folders = []
        self.selected_software = []  # Track selected software

    def display(self, selected_row_idx):
        height, width = self.stdscr.getmaxyx()

        # Define a left margin for appearance
        left_margin = 10

        # Display the main menu options
        for idx, row in enumerate(self.menu):
            x = left_margin  # Start from the left margin
            y = height // 2 - len(self.menu) // 2 + idx
            if idx == selected_row_idx:
                # Highlighted background
                self.stdscr.attron(curses.color_pair(1))
                self.stdscr.addstr(y, x, row)
                self.stdscr.attroff(curses.color_pair(1))  # Reset to default
            else:
                self.stdscr.addstr(y, x, row)

        # Refresh the menu area only
        self.stdscr.refresh()

    def handle_input(self, key, current_row):
        if key == ord('j') and current_row < len(self.menu) - 1:
            return current_row + 1
        elif key == ord('k') and current_row > 0:
            return current_row - 1
        elif key == ord('\n'):  # Enter key
            if current_row == 0:  # "Select Software" option
                self.software_folders = self.list_software_folders()
                self.selected_software = [
                    False] * (len(self.software_folders) + 1)  # +1 for "All"
                return self.show_software_selection()
        return current_row

    def list_software_folders(self):
        """List software directories under the software folder."""
        software_path = "software/"
        folders = [
            name for name in os.listdir(software_path)
            if os.path.isdir(os.path.join(software_path, name)) and
            name not in ['__init__.py', '__pycache__']  # Ignore __pycache__
        ]
        return folders

    def show_software_selection(self):
        """Display available software for selection."""
        self.stdscr.clear()
        height, width = self.stdscr.getmaxyx()

        # Add an "All" option to the beginning of the list
        software_options = ["All"] + self.software_folders
        selected_row_idx = -1  # No selection by default

        # Define a left margin for appearance
        left_margin = 10

        # Display the message at the top
        message = "Use 'i' to toggle selection, then press Enter"
        self.stdscr.addstr(1, width // 2 - len(message) // 2, message)

        while True:
            # Display available software options
            for idx, software in enumerate(software_options):
                x = left_margin  # Start from the left margin
                # Offset by 2 for the message
                y = height // 2 - len(software_options) // 2 + idx + 2
                # Mark selection
                mark = "[X]" if (
                    selected_row_idx != 1 and self.selected_software[selected_row_idx]) else "[ ]"

                if idx == selected_row_idx:
                    # Highlighted background
                    self.stdscr.attron(curses.color_pair(1))
                    self.stdscr.addstr(y, x, f"{mark} {software}")
                    # Reset to default
                    self.stdscr.attroff(curses.color_pair(1))
                else:
                    self.stdscr.addstr(y, x, f"{mark} {software}")

            # Instructions
            instructions = "Use j/k to move, i to toggle selection, Enter to confirm, q to quit"
            self.stdscr.addstr(height - 2, width // 2 -
                               len(instructions) // 2, instructions)

            # Refresh the screen
            self.stdscr.refresh()

            key = self.stdscr.getch()
            if key == ord('j') and selected_row_idx < len(software_options) - 1:
                selected_row_idx += 1
            elif key == ord('k') and selected_row_idx > 0:
                selected_row_idx -= 1
            elif key == ord('i'):
                if selected_row_idx != -1:  # Only toggle if an option is selected
                    if selected_row_idx == 0:  # Toggle "All"
                        all_selected = all(self.selected_software)
                        self.selected_software = [
                            # Select/deselect all
                            not all_selected] * (len(self.software_folders) + 1)
                    else:
                        # Toggle selection
                        self.selected_software[selected_row_idx -
                                               1] = not self.selected_software[selected_row_idx - 1]
            elif key == ord('\n'):
                if selected_row_idx != -1:  # Only proceed if an option is selected
                    # Here we can handle installation or configuration based on selected software
                    self.stdscr.clear()
                    selected_list = [software_options[idx] for idx, selected in enumerate(
                        self.selected_software) if selected]
                    self.stdscr.addstr(height // 2, width // 2 -
                                       10, f"Selected: {', '.join(selected_list)}")
                    self.stdscr.refresh()
                    self.stdscr.getch()  # Wait for a key press
                    break
            elif key == ord('q'):
                break

        return 0  # Return to the main menu

    def should_exit(self, key, current_row):
        if key == ord('q') or (key == ord('\n') and current_row == len(self.menu) - 1):
            return True
        return False
