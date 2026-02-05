#!/bin/bash
# =============================================================================
# Project: popos_toolkit
# File: install_asus_tools.sh
# Description: Initial setup for ASUS ROG Zephyrus G14 (2024) on Pop!_OS 24.04.
# Author: madogan
# =============================================================================

set -e # Exit immediately if a command exits with a non-zero status

echo "📦 Installing system dependencies..."
sudo apt update
sudo apt install -y libdbus-1-dev libudev-dev libfontconfig1-dev libseat-dev \
    pkg-config make git libusb-1.0-0-dev libclang-dev build-essential

# Ensure Rust toolchain is available for source compilation
if ! command -v cargo &> /dev/null; then
    echo "🦀 Rust not found. Installing via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Create directory for source code management
mkdir -p ~/src/asus-linux
cd ~/src/asus-linux

echo "📥 Cloning source repositories from GitLab..."
[ -d "asusctl" ] || git clone https://gitlab.com/asus-linux/asusctl.git
[ -d "supergfxctl" ] || git clone https://gitlab.com/asus-linux/supergfxctl.git

echo "🛠️ Compiling and installing asusctl..."
cd asusctl && make && sudo make install
cd ..

echo "🛠️ Compiling and installing supergfxctl..."
cd supergfxctl && make && sudo make install

echo "🛑 Resolving Pop!_OS power management conflicts..."
# We mask system76-power because it competes for control of the same hardware
sudo systemctl disable --now system76-power || true
sudo systemctl mask system76-power

echo "🔄 Initializing systemd services..."
sudo systemctl daemon-reload
sudo systemctl enable --now asusd supergfxd

echo "✅ Setup complete! A system reboot is highly recommended."
