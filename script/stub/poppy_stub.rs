use std::io::{self, Write};

fn main() {
    let stdout = io::stdout();
    let mut out = stdout.lock();
    let _ = writeln!(out, "Poppy v0.1.0-stub");
    let _ = writeln!(out, "=================");
    let _ = writeln!(out);
    let _ = writeln!(out, "This is a placeholder installer payload.");
    let _ = writeln!(out, "The real Poppy build is being assembled by CI:");
    let _ = writeln!(out, "  https://github.com/yanimeziani/poppy/actions");
    let _ = writeln!(out);
    let _ = writeln!(
        out,
        "When the full build lands, re-run the installer — it upgrades in place."
    );
    let _ = writeln!(out);
    let _ = write!(out, "Press Enter to exit... ");
    let _ = out.flush();
    let mut s = String::new();
    let _ = io::stdin().read_line(&mut s);
}
