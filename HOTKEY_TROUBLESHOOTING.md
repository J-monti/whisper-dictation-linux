# Hotkey Not Working? Here's How to Fix It

## The Problem

The global hotkey (Ctrl+Shift+Space) isn't working because `PyKDE5` is not installed. This is a Python library that allows apps to register global shortcuts in KDE.

## Quick Solution: Use the System Tray Icon

**You don't need the hotkey!** The system tray icon works perfectly:

### Method 1: Right-Click Menu
1. Right-click the microphone icon in system tray
2. Click "▶ Start Dictation"
3. Speak your text
4. Right-click again and click "⏹ Stop Dictation"

### Method 2: Double-Click
1. Double-click the microphone icon
2. Speak your text
3. Double-click again to stop

The icon will change when recording:
- 🎤 **Red recording icon** = Currently recording
- 🎙️ **Gray microphone** = Inactive/ready

## Permanent Fix: Install PyKDE5

If you really want the global hotkey:

```bash
# Activate your venv
cd kde-vosk-dictation
source venv/bin/activate

# Install PyKDE5
pip install pykde5

# Restart the daemon
./run.sh
```

**Note:** PyKDE5 installation can sometimes fail due to compilation issues. If it doesn't work, just use the tray icon method - it's actually faster!

## Alternative: Manual KDE Shortcut

You can set up a custom KDE shortcut yourself:

### Step 1: Keep the daemon running
```bash
./run.sh
```

### Step 2: Set up KDE Custom Shortcut

1. Open **System Settings**
2. Go to **Shortcuts** → **Custom Shortcuts**
3. Click **Edit** → **New** → **Global Shortcut** → **Command/URL**
4. Give it a name: "Vosk Dictation Toggle"
5. In the **Trigger** tab:
   - Click the button and press **Ctrl+Shift+Space**
6. In the **Action** tab, enter:
   ```
   qdbus org.kde.VoskDictation /VoskDictation org.kde.VoskDictation.Toggle
   ```
7. Click **Apply**

Now your custom shortcut will work!

## Why Doesn't PyKDE5 Install Easily?

PyKDE5 is an older library that requires:
- KDE development headers
- Qt5 development files
- C++ compilation

On modern systems, it's often easier to just use the tray icon or set up a manual KDE shortcut.

## Recommended Approach

**Just use the tray icon!** Here's why:
- ✅ Always works, no dependencies
- ✅ Visual feedback (icon changes)
- ✅ No compilation needed
- ✅ More reliable
- ✅ Works on any desktop environment

The double-click method is particularly fast once you get used to it.

## Stopping Ctrl+C Issue

If Ctrl+C doesn't stop the daemon (the original issue), this has been fixed in the updated version. The new code properly handles SIGINT signals.

If you're still having issues:

```bash
# Force kill if needed
pkill -f dictation_daemon.py

# Or find the process
ps aux | grep dictation_daemon
kill <PID>
```

## Testing the Fix

After updating to the fixed version:

1. Start the daemon: `./run.sh`
2. Right-click tray icon
3. You should see either "▶ Start Dictation" or "⏹ Stop Dictation"
4. The menu text should toggle when you click it
5. The tray icon should change color when recording
6. Ctrl+C in terminal should cleanly shut down

## Summary

**You have THREE working options:**

1. **Tray Icon Double-Click** ⭐ Recommended - Fastest and most reliable
2. **Tray Icon Menu** - Right-click, click menu item
3. **Global Hotkey** - Requires PyKDE5 or manual KDE setup

Pick whichever works best for you!
