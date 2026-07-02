#!/bin/sh
set -e

TEMP_DIR="./run_script_temp"
REPO_DIR="$TEMP_DIR/run"

echo "Creating temporary directory..."
mkdir -p "$TEMP_DIR"

echo "Cloning https://github.com/catilgrass/run ..."
git clone https://github.com/catilgrass/run "$REPO_DIR"

echo "Removing unwanted files..."
rm -f "$REPO_DIR/README.md" "$REPO_DIR/LICENSE"
rm -rf "$REPO_DIR/install"

echo "Removing git data..."
rm -rf "$REPO_DIR/.git"

echo "Installing files..."
cp -a "$REPO_DIR/." .
chmod +x run.sh

echo "Cleaning up temporary directory..."
rm -rf "$TEMP_DIR"

echo "Done!"
