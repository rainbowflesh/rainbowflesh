use std::io::Write;
use termcolor::{Color, ColorChoice, ColorSpec, StandardStream, WriteColor};

fn print_credits() {
    // no help! banner for copyright
    let ascii_art =[
    "        ",
    " /$$$$$$$            /$$           /$$                               /$$$$$$$$ /$$                     /$$      ",
    "| $$__  $$          |__/          | $$                              | $$_____/| $$                    | $$      ",
    r"| $$  \ $$  /$$$$$$  /$$ /$$$$$$$ | $$$$$$$   /$$$$$$  /$$  /$$  /$$| $$      | $$  /$$$$$$   /$$$$$$$| $$$$$$$ ",
    "| $$$$$$$/ |____  $$| $$| $$__  $$| $$__  $$ /$$__  $$| $$ | $$ | $$| $$$$$   | $$ /$$__  $$ /$$_____/| $$__  $$",
    r"| $$__  $$  /$$$$$$$| $$| $$  \ $$| $$  \ $$| $$  \ $$| $$ | $$ | $$| $$__/   | $$| $$$$$$$$|  $$$$$$ | $$  \ $$",
    r"| $$  \ $$ /$$__  $$| $$| $$  | $$| $$  | $$| $$  | $$| $$ | $$ | $$| $$      | $$| $$_____/ \____  $$| $$  | $$",
    "| $$  | $$ | $$$$$$$| $$| $$  | $$| $$$$$$$/|  $$$$$$/|  $$$$$/$$$$/| $$      | $$|  $$$$$$$ /$$$$$$$/| $$  | $$",
    r"|__/  |__/ \_______/|__/|__/  |__/|_______/  \______/  \_____/\___/ |__/      |__/ \_______/|_______/ |__/  |__/",
    "                                       佛祖保佑 0 error 0 warning"
    ];
    let mut stdout = StandardStream::stdout(ColorChoice::Always);
    let color_map = [
        (0, Color::White),
        (1, Color::Red),
        (2, Color::Red),
        (3, Color::Yellow),
        (4, Color::Green),
        (5, Color::Green),
        (6, Color::Blue),
        (7, Color::Blue),
        (8, Color::Cyan),
        (9, Color::Magenta),
        (10, Color::Black),
    ];
    for (i, line) in ascii_art.iter().enumerate() {
        if let Some((_index, color)) = color_map.iter().find(|&(index, _)| *index == i) {
            _ = stdout.set_color(ColorSpec::new().set_fg(Some(*color)));
        }
        _ = writeln!(&mut stdout, "{}", line);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_print_credits() {
        print_credits();
    }
}

