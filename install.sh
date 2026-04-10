#!/bin/bash
set -e

echo "Building release binary..."
cargo build --release

echo "Installing binary to ~/.local/bin/"
mkdir -p ~/.local/bin
cp target/release/dictation ~/.local/bin/dictation

echo "Installing systemd user service..."
mkdir -p ~/.config/systemd/user
cp dictation.service ~/.config/systemd/user/

echo "Reloading systemd and enabling service..."
systemctl --user daemon-reload
systemctl --user enable --now dictation

echo ""
echo "Done! Dictation daemon is running."
echo "  Status:  systemctl --user status dictation"
echo "  Logs:    journalctl --user -u dictation -f"
echo "  Stop:    systemctl --user stop dictation"
echo "  Restart: systemctl --user restart dictation"
