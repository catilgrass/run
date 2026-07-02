#!/bin/sh
echo ""
echo '  Welcome to use `run.sh` / `run.ps1`'
echo ""
echo '  > "Hello World"'
echo "  > cwd  : \"$(pwd)\""
items=""
sep=""
for arg in "$@"; do
    items="${items}${sep}\"${arg}\""
    sep=", "
done
echo "  > args : ${items}"
echo ""
