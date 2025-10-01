#!/bin/bash

# install.sh - installer for your AI CLI tool

set -e

BIN_NAME="ai"
TOOL_NAME="ai-term"
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="script.sh"
SCRIPT_URL="https://raw.githubusercontent.com/MushroomWasp/ai-term/refs/heads/main/script.sh"

echo "[*] Installing $TOOL_NAME..."

# Check required dependencies
for cmd in curl jq; do
  if ! command -v "$cmd" &> /dev/null; then
    echo "[!] Missing dependency: $cmd"
    echo "    Please install it first."
    exit 1
  fi
done

# Check for glow (optional)
if ! command -v glow &> /dev/null; then
  echo "[!] Glow is not installed."
  echo "    Install it from: https://github.com/charmbracelet/glow"
  echo "    (Your output will still work, but glow makes it prettier.)"
fi

# Download the script from GitHub
echo "[*] Fetching latest script from GitHub..."
curl -sL "$SCRIPT_URL" -o "/tmp/$SCRIPT_NAME"

# Copy to /usr/local/bin
chmod +x "/tmp/$SCRIPT_NAME"
sudo cp "/tmp/$SCRIPT_NAME" "$INSTALL_DIR/$BIN_NAME"

echo
echo "[+] Installed $TOOL_NAME to $INSTALL_DIR/$BIN_NAME"
echo
echo "Usage:"
echo "  $BIN_NAME \"your prompt here\""
echo "  $BIN_NAME -c \"your prompt here\"   # code-only mode"
echo "[!] Make sure to set your API KEY in $INSTALL_DIR/$BIN_NAME"

