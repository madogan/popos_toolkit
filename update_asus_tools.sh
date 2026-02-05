#!/bin/bash
# =============================================================================
# Project: popos_toolkit
# File: update_asus_tools.sh
# Description: Fetches latest changes and recompiles ASUS daemons.
# Author: madogan
# =============================================================================

set -e

# Path to the source code directory defined in the install script
SOURCE_DIR="$HOME/src/asus-linux"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ Error: Source directory not found. Please run install_asus.sh first."
    exit 1
fi

cd "$SOURCE_DIR"

echo "🔄 Updating asusctl..."
cd asusctl
git fetch && git pull
make
sudo make install
cd ..

echo "🔄 Updating supergfxctl..."
cd supergfxctl
git fetch && git pull
make
sudo make install

echo "⚡ Reloading systemd configurations..."
sudo systemctl daemon-reload
sudo systemctl restart asusd supergfxd

echo "✨ ASUS Toolkit is now up to date."
echo "Current versions:"
asusctl --version
supergfxctl --version
