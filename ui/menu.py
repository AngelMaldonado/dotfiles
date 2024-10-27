from ui.colors import AnsiColor
from ui.drawable import Drawable

welcome = """
██████╗░██╗░░░██╗██████╗░░█████╗░████████╗
██╔══██╗╚██╗░██╔╝██╔══██╗██╔══██╗╚══██╔══╝
██████╔╝░╚████╔╝░██║░░██║██║░░██║░░░██║░░░
██╔═══╝░░░╚██╔╝░░██║░░██║██║░░██║░░░██║░░░
██║░░░░░░░░██║░░░██████╔╝╚█████╔╝░░░██║░░░
╚═╝░░░░░░░░╚═╝░░░╚═════╝░░╚════╝░░░░╚═╝░░░

🚀 by: @AngelMaldonado
😸 Github: https://github.com/AngelMaldonado
"""


class Menu(Drawable):
    def __init__(self, options):
        self.options = options
        self.selected_index = 0
        self.instructions = "𝕌𝕤𝕖 𝕛/𝕜 𝕥𝕠 𝕞𝕠𝕧𝕖, 𝕒𝕟𝕕 𝕢 𝕥𝕠 𝕢𝕦𝕚𝕥."

    def draw(self):
        """Draws the menu options to the screen."""
        print(welcome)
        print(self.instructions)
        for idx, option in enumerate(self.options):
            if idx == self.selected_index:
                print(f"👉 {AnsiColor.GREEN.apply(option['label'])}")
            else:
                print(f"  {option['label']}")
        print(AnsiColor.HIDE_CURSOR.value)

    def handle_input(self, key):
        if key == 'j':
            self.selected_index = (self.selected_index + 1) % len(self.options)
        elif key == 'k':
            self.selected_index = (self.selected_index - 1) % len(self.options)
        elif key == 'q':
            print("Exiting the menu.")
            exit(0)
