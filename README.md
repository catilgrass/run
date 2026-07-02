# 'run'

> Screw "make", I just want a script runner

Sometimes when working on projects, I need cross-platform operation. I don't want to install something like `just` or `make`. I just want to write some scripts, drop them in, and run them. That's it.

This is the solution:

- Rust program? Drop it in `.run/src/bin/myscript.rs`
- C#? Drop it in `.run/src/bin/myscript.cs`
- Python? Drop it in `.run/src/bin/myscript.py`
- Shell? PowerShell? Same!

Any script can be dropped in. After that, just run `.\run.ps1 script-name` or `./run.sh script-name`.

## Install

For Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/catilgrass/run/refs/heads/master/install/install.sh | bash
chmod +x run.sh
```

For Windows:

```bash
iwr -useb https://raw.githubusercontent.com/catilgrass/run/refs/heads/master/install/install.ps1 | iex
```

## Or manually install

For Linux:

```bash
cd your-project
git clone https://github.com/catilgrass/run
mv run/.run run/run.ps1 run/run.sh ./
rm -rf run
```

For Windows:

```powershell
cd your-project
git clone https://github.com/catilgrass/run

Move-Item -Path "run/.run" -Destination "./.run" -Force
Move-Item -Path "run/run.ps1" -Destination "./run.ps1" -Force
Move-Item -Path "run/run.sh" -Destination "./run.sh" -Force

Remove-Item -Path "run" -Recurse -Force
```

## Usage

```bash
./run.sh                 # Show all scripts
./run.sh python-script   # Run any script
./run.sh 3               # Run by number
./run.sh 3 Hello World   # Run with arguments
```

## License

WTFPL — drop it into your project and use it.
