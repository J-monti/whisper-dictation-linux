# Alternative: Using System Packages (Arch Linux)

If you prefer to use system packages instead of a virtual environment, you can install everything via pacman and yay/paru.

## Prerequisites

1. Install an AUR helper if you don't have one:
```bash
# Using yay
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Installation Steps

### 1. Install All Dependencies from Arch Repos

```bash
# Core dependencies
sudo pacman -S python python-pyaudio python-pyqt5 portaudio wtype

# Install vosk from AUR
yay -S python-vosk
```

### 2. Download Vosk Model

```bash
mkdir -p ~/vosk-models
cd ~/vosk-models

# Download small English model
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
unzip vosk-model-small-en-us-0.15.zip
```

### 3. Run Directly Without venv

Since all dependencies are system packages, you can run the daemon directly:

```bash
cd kde-vosk-dictation
chmod +x dictation_daemon.py
./dictation_daemon.py
```

Or specify a model:
```bash
./dictation_daemon.py ~/vosk-models/vosk-model-small-en-us-0.15
```

## Systemd Service (System Packages Version)

If using system packages, update the service file to call the Python script directly:

```bash
mkdir -p ~/.config/systemd/user
cp vosk-dictation.service ~/.config/systemd/user/

# Edit the service file to use dictation_daemon.py directly
sed -i 's|run.sh|dictation_daemon.py|' ~/.config/systemd/user/vosk-dictation.service

# Enable and start
systemctl --user enable --now vosk-dictation
```

## Desktop Entry (System Packages Version)

Update the desktop file similarly:

```bash
mkdir -p ~/.local/share/applications
cp vosk-dictation.desktop ~/.local/share/applications/

# Edit to use dictation_daemon.py directly
sed -i 's|run.sh|dictation_daemon.py|' ~/.local/share/applications/vosk-dictation.desktop
```

## Pros and Cons

### System Packages Approach
**Pros:**
- No virtual environment overhead
- Easier system integration
- Updates via pacman
- Slightly faster startup

**Cons:**
- Dependency on AUR (python-vosk)
- May conflict with other Python projects
- Less portable to other distros

### Virtual Environment Approach (Default)
**Pros:**
- Works on any distro
- Isolated dependencies
- No system package conflicts
- Follows Python best practices

**Cons:**
- Slightly more disk space (~100MB)
- Need to use run.sh launcher
- Can't update via pacman

## Recommendation

**For Arch users who:**
- Only use Arch Linux → System packages is fine
- Want updates via pacman → System packages
- Develop Python projects → Use venv (default)
- Want maximum portability → Use venv (default)

Both approaches work perfectly! Choose what fits your workflow.
