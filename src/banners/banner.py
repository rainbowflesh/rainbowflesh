def print_banner():
    line = ''' /$$$$$$$            /$$           /$$                               /$$$$$$$$ /$$                     /$$      '''
    line1 = '''| $$__  $$          |__/          | $$                              | $$_____/| $$                    | $$      '''
    line2 = '''| $$  \ $$  /$$$$$$  /$$ /$$$$$$$ | $$$$$$$   /$$$$$$  /$$  /$$  /$$| $$      | $$  /$$$$$$   /$$$$$$$| $$$$$$$ '''
    line3 = '''| $$$$$$$/ |____  $$| $$| $$__  $$| $$__  $$ /$$__  $$| $$ | $$ | $$| $$$$$   | $$ /$$__  $$ /$$_____/| $$__  $$'''
    line4 = '''| $$__  $$  /$$$$$$$| $$| $$  \ $$| $$  \ $$| $$  \ $$| $$ | $$ | $$| $$__/   | $$| $$$$$$$$|  $$$$$$ | $$  \ $$'''
    line5 = '''| $$  \ $$ /$$__  $$| $$| $$  | $$| $$  | $$| $$  | $$| $$ | $$ | $$| $$      | $$| $$_____/ \____  $$| $$  | $$'''
    line6 = '''| $$  | $$|  $$$$$$$| $$| $$  | $$| $$$$$$$/|  $$$$$$/|  $$$$$/$$$$/| $$      | $$|  $$$$$$$ /$$$$$$$/| $$  | $$'''
    line7 = '''|__/  |__/ \_______/|__/|__/  |__/|_______/  \______/  \_____/\___/ |__/      |__/ \_______/|_______/ |__/  |__/'''
    line8 = '''                                       佛祖保佑 0 error 0 warning'''

    def _print_red(skk): print("\033[91m {}\033[00m".format(skk))
    def _print_yellow(skk): print("\033[93m {}\033[00m".format(skk))
    def _print_blue(skk): print("\034[94m {}\034[00m".format(skk))
    def _print_green(skk): print("\033[92m {}\033[00m".format(skk))
    def _print_cyan(skk): print("\033[96m {}\033[00m".format(skk))
    def _print_magenta(skk): print("\033[94m {}\033[00m".format(skk))
    def _print_purple(skk): print("\033[95m {}\033[00m".format(skk))
    def _print_black(skk): print("\033[98m {}\033[00m".format(skk))
    def _print_gray(skk): print("\033[97m {}\033[00m".format(skk))
    def _print_white(skk): print("\033[99m {}\033[00m".format(skk))

    _print_red(line)
    _print_yellow(line1)
    _print_blue(line2)
    _print_green(line3)
    _print_cyan(line4)
    _print_magenta(line5)
    _print_purple(line6)
    _print_black(line7)
    _print_white(line8)
