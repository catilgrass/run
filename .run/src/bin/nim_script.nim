#!/usr/bin/env nim

import os

let cwd = getCurrentDir()
var args = ""
for i, a in commandLineParams():
  if i > 0: args.add(", ")
  args.add("\"")
  args.add(a)
  args.add("\"")

echo ""
echo "  Welcome to use `run.sh` / `run.ps1`"
echo ""
echo "  > \"Hello World\""
echo "  > cwd  : \"" & cwd & "\""
echo "  > args : " & args
echo ""
