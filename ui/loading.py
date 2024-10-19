import curses


def loading_animation(stdscr, duration=2):
    stdscr.clear()
    stdscr.addstr(0, 0, "Loading...")
    stdscr.refresh()
    curses.napms(duration * 1000)  # Simulates a loading time
