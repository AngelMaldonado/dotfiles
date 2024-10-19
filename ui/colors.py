import curses


class ColorChannels:
    NORMAL_TEXT = 1
    SELECTED_TEXT = 2
    WARNING_TEXT = 3

    @staticmethod
    def initialize_colors():
        """Initialize color pairs (channels)."""
        curses.start_color()
        curses.init_pair(ColorChannels.NORMAL_TEXT,
                         curses.COLOR_WHITE, curses.COLOR_BLACK)
        curses.init_pair(ColorChannels.SELECTED_TEXT,
                         curses.COLOR_BLACK, curses.COLOR_CYAN)
        curses.init_pair(ColorChannels.WARNING_TEXT,
                         curses.COLOR_YELLOW, curses.COLOR_BLACK)
