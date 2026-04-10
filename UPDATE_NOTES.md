# Update: Fixed PEP 668 Error

## What Changed

The installer has been updated to properly handle modern Linux distributions (Arch, Ubuntu 23.04+, Fedora, etc.) that implement PEP 668 - a protection against corrupting system Python packages.

## What's New

### 1. Virtual Environment Support (Default)
- ✅ Installer now creates a Python venv automatically
- ✅ All dependencies installed in isolated environment
- ✅ No conflicts with system packages
- ✅ Fully PEP 668 compliant

### 2. New Launcher Script: `run.sh`
- Automatically activates venv before running
- Handles all the complexity for you
- Just run `./run.sh` instead of `./dictation_daemon.py`

### 3. New Documentation
- **VENV_TROUBLESHOOTING.md** - Comprehensive venv help
- **ARCH_SYSTEM_PACKAGES.md** - Alternative for system packages (Arch only)

## How to Use (Updated)

### Quick Install
```bash
cd kde-vosk-dictation

# 1. Make installer executable
chmod +x install.sh

# 2. Run installer (creates venv automatically)
./install.sh

# 3. Start dictating!
./run.sh
```

That's it! The installer handles everything.

## What Happens Behind the Scenes

```
install.sh:
1. Creates venv/ directory with isolated Python
2. Installs vosk, PyAudio, PyQt5 in venv
3. Downloads Vosk model
4. Makes scripts executable

run.sh:
1. Checks venv exists
2. Runs: venv/bin/python dictation_daemon.py
3. All dependencies available automatically
```

## File Structure After Install

```
kde-vosk-dictation/
├── venv/                          # NEW: Virtual environment
│   ├── bin/python                 # Isolated Python
│   ├── lib/python3.x/site-packages/  # Dependencies here
│   └── ...
├── run.sh                         # NEW: Launcher script
├── install.sh                     # UPDATED: Creates venv
├── dictation_daemon.py           # Unchanged
├── README.md                     # UPDATED: New instructions
└── ...
```

## Disk Space

The venv adds approximately:
- **150MB** for venv and Python packages
- **40MB-2GB** for Vosk models (you choose)
- **Total:** ~200MB to 2.2GB

This is isolated and can be completely removed by deleting the `venv/` folder.

## For Advanced Users

### If You Want System Packages Instead

See `ARCH_SYSTEM_PACKAGES.md` for instructions on using pacman/AUR packages instead of venv.

**Pros:** Smaller footprint, pacman updates  
**Cons:** AUR dependency, less portable

### Manual venv Management

```bash
# Activate venv manually
source venv/bin/activate

# Now you can use python/pip directly
python dictation_daemon.py
pip list

# Deactivate when done
deactivate
```

## Compatibility

### Works On
✅ Arch Linux (all versions)  
✅ Manjaro  
✅ EndeavourOS  
✅ Ubuntu 23.04+  
✅ Debian 12+  
✅ Fedora 38+  
✅ Any modern Linux with Python 3.7+  

### Why This Matters

PEP 668 is now standard on most distributions:
- **Arch Linux**: Since always (via pacman protection)
- **Ubuntu**: Since 23.04
- **Debian**: Since Debian 12
- **Fedora**: Since F38

This update ensures the project works everywhere, not just on older systems.

## Migration from Old Version

If you installed before this update:

```bash
# 1. Remove old global install (if any)
pip uninstall vosk PyAudio PyQt5

# 2. Clean the directory
cd kde-vosk-dictation
rm -rf venv/  # If exists

# 3. Reinstall with new method
./install.sh

# 4. Use new launcher
./run.sh
```

## Troubleshooting

### "externally-managed-environment" Error
✅ **Fixed!** This error won't happen with the new installer.

### "venv module not found"
```bash
# Install venv (usually included with Python)
sudo pacman -S python      # Arch
sudo apt install python3-venv  # Ubuntu/Debian
```

### Other Issues
See `VENV_TROUBLESHOOTING.md` for comprehensive help.

## Benefits of This Approach

1. **No System Pollution** - System Python stays pristine
2. **Reproducible** - Same environment everywhere
3. **Safe** - Can't break system packages
4. **Standard** - Follows Python best practices
5. **Portable** - Works on all distros
6. **Easy Cleanup** - Just `rm -rf venv/`

## Questions?

- Read `VENV_TROUBLESHOOTING.md` for detailed venv help
- Read `ARCH_SYSTEM_PACKAGES.md` for system package alternative
- Check `README.md` for full documentation
- Open an issue if you still have problems

---

**TL;DR:** Run `./install.sh`, then run `./run.sh`. Everything else is automatic. 🚀
