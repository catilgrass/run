fn main() {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let cwd = std::env::current_dir().unwrap();
    println!();
    println!("  Welcome to use `run.sh` / `run.ps1`");
    println!();
    println!("  > \"Hello World\"");
    println!("  > cwd  : \"{}\"", cwd.display());
    let args_str: Vec<String> = args.iter().map(|a| format!("\"{}\"", a)).collect();
    println!("  > args : {}", args_str.join(", "));
    println!();
}
