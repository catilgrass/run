#!/bin/sh
set -e

TEMP_DIR="./run_script_temp"
REPO_DIR="$TEMP_DIR/run"

echo "Creating temporary directory..."
mkdir -p "$TEMP_DIR"

echo "Cloning https://github.com/catilgrass/run ..."
git clone https://github.com/catilgrass/run "$REPO_DIR"

echo "Installing files..."
cp -a "$REPO_DIR/run.sh" .
cp -a "$REPO_DIR/run.ps1" .
cp -a "$REPO_DIR/.run" .
chmod +x run.sh

echo "Cleaning up..."
rm -rf "$TEMP_DIR"

echo "Done!"
