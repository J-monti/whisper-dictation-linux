# whisper-dictation-linux

A local, privacy-focused dictation daemon for Linux. Press a hotkey, speak, and text appears at your cursor. Powered by [OpenAI Whisper](https://github.com/openai/whisper) running entirely on your machine — no cloud services, no data leaves your computer.

## Features

- **Fully local** — all speech recognition runs on-device via Whisper
- **Global hotkey** — Ctrl+Shift+Space to start/stop dictation from anywhere
- **Works on Wayland and X11** — text injection via ydotool or wtype
- **Desktop-agnostic** — KDE, GNOME, Sway, Hyprland, etc.
- **System tray icon** — visual recording indicator (green = ready, red = recording)
- **Smart Punctuation** — Whisper auto-punctuates by default; toggle off in tray menu if you prefer voice commands for punctuation
- **Voice commands** — built-in coding symbol dictation (braces, arrows, operators, etc.)
- **Auto-stop safety** — recording caps at 60 seconds to prevent runaway capture
- **Clean shutdown** — releases all key state on SIGTERM/SIGINT

## Requirements

- Linux (Wayland or X11)
- Rust toolchain (for building)
- A Whisper GGML model file
- **ydotool** (recommended) or **wtype** for text injection
- A microphone

## Installation

### 1. Install system dependencies

**Arch/Manjaro:**
```bash
sudo pacman -S base-devel cmake ydotool
sudo systemctl enable --now ydotool
```

**Ubuntu/Debian:**
```bash
sudo apt install build-essential cmake libclang-dev libasound2-dev libdbus-1-dev ydotool
sudo systemctl enable --now ydotool
```

**Fedora:**
```bash
sudo dnf install gcc cmake clang-devel alsa-lib-devel dbus-devel ydotool
sudo systemctl enable --now ydotool
```

> **Note:** ydotool requires its daemon running (`ydotoold`). The systemd service handles this. Your user needs to be in the `input` group: `sudo usermod -aG input $USER` (then log out/in).

### 2. Download a Whisper model

```bash
mkdir -p ~/whisper-models
cd ~/whisper-models

# Base English model (~150MB) — good balance of speed and accuracy
wget https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin
```

Other model sizes (speed vs. accuracy tradeoff):

| Model | Size | Notes |
|-------|------|-------|
| `ggml-tiny.en.bin` | ~75MB | Fastest, lower accuracy |
| `ggml-base.en.bin` | ~150MB | Good default |
| `ggml-small.en.bin` | ~500MB | Better accuracy |
| `ggml-medium.en.bin` | ~1.5GB | High accuracy, slower |

Browse all models at [huggingface.co/ggerganov/whisper.cpp](https://huggingface.co/ggerganov/whisper.cpp/tree/main).

### 3. Build and install

```bash
git clone https://github.com/J-monti/whisper-dictation-linux.git
cd whisper-dictation-linux
./install.sh
```

This builds the release binary, installs it to `~/.local/bin/`, and sets up a systemd user service that starts automatically on login.

**Or build manually:**
```bash
cargo build --release
./target/release/dictation
```

### 4. Verify it's running

```bash
systemctl --user status dictation
```

You should see a green or red circle in your system tray.

## Usage

1. **Press Ctrl+Shift+Space** — starts recording (tray icon turns red)
2. **Speak** — say what you want typed
3. **Press Ctrl+Shift+Space again** — stops recording, transcribes, and types the text at your cursor

### Custom model path

By default the daemon looks for `~/whisper-models/ggml-base.en.bin`. To use a different model:

```bash
dictation /path/to/your/ggml-model.bin
```

### Smart Punctuation

By default, **Smart Punctuation is ON**. Whisper automatically adds commas, periods, question marks, and other punctuation to your text — you just speak naturally.

If you prefer to control punctuation yourself by saying "comma", "period", etc., right-click the tray icon and toggle **Smart Punctuation: OFF**. This enables the full set of punctuation voice commands:

| Say | Types |
|-----|-------|
| "period" | `.` |
| "comma" | `,` |
| "question mark" | `?` |
| "exclamation mark" | `!` |
| "colon" | `:` |
| "semicolon" | `;` |
| "dash" | `-` |
| "ellipsis" | `...` |
| "new line" | newline |
| "new paragraph" | double newline |
| "open quote" / "close quote" | `"` |
| "open paren" / "close paren" | `(` `)` |

### Voice commands

Coding and special symbol commands are **always active** regardless of the Smart Punctuation setting:

**Programming:**

| Say | Types |
|-----|-------|
| "open brace" / "close brace" | `{` `}` |
| "open bracket" / "close bracket" | `[` `]` |
| "equals" | `=` |
| "double equals" | `==` |
| "not equals" | `!=` |
| "fat arrow" | `=>` |
| "thin arrow" | `->` |
| "plus equals" | `+=` |
| "pipe pipe" | `\|\|` |
| "double ampersand" | `&&` |
| "scope resolution" | `::` |
| "underscore" | `_` |
| "backtick" | `` ` `` |
| "hashtag" | `#` |

Common dev terms (API, GitHub, JSON, PostgreSQL, etc.) are automatically capitalized correctly.

## Managing the service

```bash
# Check status
systemctl --user status dictation

# View logs
journalctl --user -u dictation -f

# Restart
systemctl --user restart dictation

# Stop
systemctl --user stop dictation

# Disable autostart
systemctl --user disable dictation
```

## Troubleshooting

### Text not appearing after dictation

1. Check that ydotool daemon is running:
   ```bash
   systemctl status ydotool
   ```
2. Check your user is in the `input` group:
   ```bash
   groups | grep input
   ```
   If not: `sudo usermod -aG input $USER` and log out/in.

### Hotkey not responding

Check if another application has grabbed Ctrl+Shift+Space. The daemon uses `rdev` to listen for key events, which requires read access to `/dev/input/` devices.

```bash
# Check if the daemon is running
systemctl --user status dictation

# Check logs for errors
journalctl --user -u dictation --no-pager -n 20
```

### Stuck keys after a crash

If the daemon was killed mid-injection (e.g., `kill -9`), keys can get stuck at the uinput level. Run the included cleanup script:

```bash
./cleanup.sh
```

This releases spacebar, ctrl, and shift via ydotool.

### No microphone detected

```bash
# List audio input devices
arecord -l

# Test recording
arecord -d 3 -f S16_LE -r 16000 /tmp/test.wav && aplay /tmp/test.wav
```

Make sure your microphone is set as the default input device in your audio settings (PulseAudio/PipeWire).

## How it works

```
Ctrl+Shift+Space
        |
        v
  rdev key listener ──> toggle_dictation()
        |                      |
        |              ┌───────┴───────┐
        |              v               v
        |          START            STOP
        |        (record)       (transcribe)
        |              |               |
        |              v               v
        |         cpal audio      whisper-rs
        |         stream ──>      inference
        |         buffer             |
        |                            v
        |                     process_text()
        |                     (punctuation,
        |                      dev terms)
        |                            |
        |                            v
        |                     inject_text()
        |                     (ydotool/wtype)
        v
  System tray icon
  (green/red indicator)
```

## License

MIT License. See [LICENSE](LICENSE) for details.
