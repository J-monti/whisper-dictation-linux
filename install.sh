#!/bin/bash
set -e

# Check runtime dependencies
missing=()

if ! command -v ydotool &>/dev/null; then
    if ! command -v wtype &>/dev/null; then
        missing+=("ydotool or wtype (text injection — at least one is required)")
    else
        echo "INFO: ydotool not found, will use wtype for text injection."
    fi
fi

if ! command -v playerctl &>/dev/null; then
    echo "INFO: playerctl not found. 'Pause Media on Record' will fall back to dbus-send."
    echo "  Install with: sudo pacman -S playerctl"
fi

if [ ${#missing[@]} -gt 0 ]; then
    echo "ERROR: Missing required dependencies:"
    for dep in "${missing[@]}"; do
        echo "  - $dep"
    done
    echo ""
    echo "Arch/Manjaro:    sudo pacman -S ydotool"
    echo "Ubuntu/Debian:   sudo apt install ydotool"
    echo "Fedora:          sudo dnf install ydotool"
    exit 1
fi

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
