import os
import sys

print()
print("  Welcome to use `run.sh` / `run.ps1`")
print()
print('  > "Hello World"')
print(f'  > cwd  : "{os.getcwd()}"')
args = ", ".join(f'"{a}"' for a in sys.argv[1:])
print(f"  > args : {args}")
print()
