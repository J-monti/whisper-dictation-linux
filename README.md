# KDE Vosk Dictation - Proof of Concept

A local, privacy-focused dictation system for KDE Plasma on Wayland using the Vosk speech recognition engine.

## Features

- ✅ **Fully Local** - All processing happens on your machine
- ✅ **Privacy-First** - No cloud services, no data sent anywhere
- ✅ **Wayland Support** - Works on modern KDE Plasma Wayland sessions
- ✅ **Global Hotkey** - Press Ctrl+Shift+Space to dictate anywhere
- ✅ **System Tray Integration** - Visual feedback and manual controls
- ✅ **Lightweight** - Uses efficient Vosk models (50MB - 2GB)

## System Requirements

- KDE Plasma (Wayland or X11)
- Python 3.7+
- Microphone
- ~500MB disk space (for models)

## Installation

### 1. Install System Dependencies

**On Arch/Manjaro:**
```bash
sudo pacman -S python-pyaudio python-pyqt5 portaudio wtype
```

**On Ubuntu/Debian:**
```bash
sudo apt install python3-pyaudio python3-pyqt5 portaudio19-dev wtype
```

**On Fedora:**
```bash
sudo dnf install python3-pyaudio python3-qt5 portaudio-devel wtype
```

> **Note:** `wtype` is the recommended tool for Wayland text injection. If not available in your repos, you can compile it from [source](https://github.com/atx/wtype) or use `ydotool` as an alternative.

### 2. Install Python Dependencies

```bash
cd kde-vosk-dictation
pip install -r requirements.txt
```

### 3. Download a Vosk Model

Vosk offers several model sizes. Start with the small English model:

```bash
# Create models directory
mkdir -p ~/vosk-models
cd ~/vosk-models

# Download small English model (~40MB)
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
unzip vosk-model-small-en-us-0.15.zip

# Or download the larger, more accurate model (~1.8GB)
# wget https://alphacephei.com/vosk/models/vosk-model-en-us-0.22.zip
# unzip vosk-model-en-us-0.22.zip
```

**Available models:** https://alphacephei.com/vosk/models

Languages supported include: English, Spanish, French, German, Russian, Chinese, and many more!

### 4. Install Text Injection Tool (Wayland)

For Wayland, you need one of these tools:

**Option A: wtype (Recommended)**
```bash
# Arch
sudo pacman -S wtype

# Or build from source
git clone https://github.com/atx/wtype
cd wtype
meson build
ninja -C build
sudo ninja -C build install
```

**Option B: ydotool (Alternative)**
```bash
# Arch
yay -S ydotool-git

# Ubuntu (requires manual build)
git clone https://github.com/ReimuNotMoe/ydotool
cd ydotool
mkdir build && cd build
cmake ..
make
sudo make install

# Start ydotool daemon
sudo systemctl enable --now ydotool
```

## Usage

### Running the Daemon

```bash
cd kde-vosk-dictation
chmod +x dictation_daemon.py

# Run with default model location
./dictation_daemon.py

# Or specify a custom model path
./dictation_daemon.py ~/vosk-models/vosk-model-small-en-us-0.15
```

### Dictating

1. **Start Recording**: Press `Ctrl+Shift+Space` (or click the system tray icon)
2. **Speak Clearly**: Say what you want to type
3. **Stop Recording**: Press `Ctrl+Shift+Space` again
4. **Text Appears**: The transcribed text will be inserted at your cursor

### System Tray

The microphone icon in your system tray shows the current status:
- **Inactive**: Ready to record
- **Recording...**: Listening and processing speech

Right-click the tray icon for manual controls.

## Configuration

### Changing the Hotkey

Currently hardcoded to `Ctrl+Shift+Space`. To change, edit this line in `dictation_daemon.py`:

```python
action.setGlobalShortcut(KShortcut("Ctrl+Shift+Space"))
```

Replace with your preferred combination, e.g., `"Meta+D"`, `"Ctrl+Alt+D"`, etc.

### Using Different Languages

Download the appropriate model from [Vosk Models](https://alphacephei.com/vosk/models) and specify it when starting:

```bash
# Spanish
./dictation_daemon.py ~/vosk-models/vosk-model-small-es-0.42

# French  
./dictation_daemon.py ~/vosk-models/vosk-model-small-fr-0.22

# German
./dictation_daemon.py ~/vosk-models/vosk-model-small-de-0.15
```

### Model Size vs. Accuracy

| Model Type | Size | Accuracy | Speed | Best For |
|------------|------|----------|-------|----------|
| Small | ~40MB | Good | Fast | Quick notes, commands |
| Medium | ~1GB | Better | Medium | General dictation |
| Large | ~2GB | Best | Slower | Transcription, accuracy-critical |

## Troubleshooting

### No Text Appears

1. **Check if wtype/ydotool is installed:**
   ```bash
   which wtype
   # or
   which ydotool
   ```

2. **For ydotool, ensure daemon is running:**
   ```bash
   systemctl status ydotool
   # If not running:
   sudo systemctl start ydotool
   ```

3. **Check permissions for ydotool:**
   ```bash
   sudo usermod -aG input $USER
   # Log out and back in
   ```

### No Audio/Microphone Not Working

1. **Test microphone:**
   ```bash
   arecord -d 5 test.wav
   aplay test.wav
   ```

2. **Check PulseAudio/PipeWire:**
   ```bash
   pactl list sources short
   ```

3. **Select correct device in PulseAudio settings**

### Global Shortcut Not Working

If PyKDE5 isn't available, the global shortcut won't register automatically. You can:

1. Use the system tray menu to start/stop dictation
2. Install PyKDE5: `pip install pykde5`
3. Set up a custom KDE shortcut manually:
   - System Settings → Shortcuts → Custom Shortcuts
   - Add new command shortcut
   - Command: `dbus-send --session --type=method_call --dest=org.kde.VoskDictation /VoskDictation org.kde.VoskDictation.Toggle`

### Model Not Found

Make sure you've downloaded and extracted a Vosk model, and the path is correct:

```bash
ls ~/vosk-models/vosk-model-small-en-us-0.15/
# Should show: am/, conf/, graph/, ivector/ files
```

## Future Enhancements

This is a proof of concept! Potential improvements:

- [ ] Proper KDE Plasma integration (KWin script)
- [ ] Configuration GUI
- [ ] Multiple language switching
- [ ] Punctuation commands ("period", "comma", etc.)
- [ ] Custom vocabulary
- [ ] Real-time streaming transcription
- [ ] GPU acceleration support
- [ ] Packaging as a proper KDE service
- [ ] .desktop file and autostart integration

## Architecture

```
┌─────────────────────────────────────┐
│   User presses Ctrl+Shift+Space     │
└───────────────┬─────────────────────┘
                │
                ▼
┌─────────────────────────────────────┐
│   DictationDaemon (Qt/DBus)         │
│   - Global shortcut handler          │
│   - System tray icon                 │
└───────────────┬─────────────────────┘
                │
                ▼
┌─────────────────────────────────────┐
│   AudioRecorder (PyAudio)           │
│   - Captures microphone input        │
│   - Streams to Vosk                  │
└───────────────┬─────────────────────┘
                │
                ▼
┌─────────────────────────────────────┐
│   Vosk STT Engine                   │
│   - Processes audio locally          │
│   - Returns transcribed text         │
└───────────────┬─────────────────────┘
                │
                ▼
┌─────────────────────────────────────┐
│   TextInjector (wtype/ydotool)      │
│   - Injects text at cursor           │
│   - Works on Wayland & X11           │
└─────────────────────────────────────┘
```

## Contributing

This is a proof of concept! Contributions welcome:
- Bug fixes
- Feature additions
- Better KDE integration
- Documentation improvements

## License

MIT License - feel free to use and modify!

## Acknowledgments

- [Vosk](https://alphacephei.com/vosk/) - Fast, offline speech recognition
- [wtype](https://github.com/atx/wtype) - Wayland text injection
- [KDE Plasma](https://kde.org/plasma-desktop/) - Amazing desktop environment

## Support

For issues or questions, please open an issue on the repository.
