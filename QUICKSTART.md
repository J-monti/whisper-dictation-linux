# Quick Start Guide

## 5-Minute Setup

### 1. Install Dependencies (one command)

**Arch/Manjaro:**
```bash
sudo pacman -S python-pyaudio python-pyqt5 portaudio wtype
```

**Ubuntu/Debian:**
```bash
sudo apt install python3-pyaudio python3-pyqt5 portaudio19-dev wtype
```

### 2. Run the Installer
```bash
chmod +x install.sh
./install.sh
```

This will:
- Install Python packages
- Download a small English model (~40MB)
- Set up everything for you

### 3. Start Dictating!
```bash
./dictation_daemon.py
```

Press **Ctrl+Shift+Space**, speak, press **Ctrl+Shift+Space** again. Done! ✨

## How It Works

1. **Press the hotkey** → Starts recording your voice
2. **Speak clearly** → Vosk transcribes in real-time
3. **Press hotkey again** → Stops recording and types the text

## Tips for Best Results

✅ **Speak naturally** - No need to talk slowly  
✅ **Use a good microphone** - Built-in laptop mics work, but external is better  
✅ **Quiet environment** - Less background noise = better accuracy  
✅ **Complete sentences** - Works best with full thoughts  
✅ **Clear pronunciation** - But don't over-enunciate  

## Common Issues

**Text not appearing?**
- Install `wtype`: `sudo pacman -S wtype`
- Or install `ydotool` and start its daemon

**Low accuracy?**
- Download a larger model (see README.md)
- Check your microphone levels
- Try speaking more clearly

**Shortcut not working?**
- Use the system tray icon instead
- Or set up a custom KDE shortcut (see README.md)

## Next Steps

- **Different language?** Download from https://alphacephei.com/vosk/models
- **Better accuracy?** Use a larger model (1-2GB)
- **Autostart?** Copy `vosk-dictation.service` to `~/.config/systemd/user/`
- **Customize?** Edit `config.ini`

## Examples of What You Can Do

- Write emails quickly
- Take meeting notes hands-free
- Code comments and documentation
- Write essays and articles
- Accessibility support
- Quick searches and messages

Enjoy your privacy-respecting, fully local dictation system! 🎤
