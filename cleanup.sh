#!/bin/bash
# Reset stuck keys after a dirty shutdown of the dictation daemon.
# Releases common modifier keys and spacebar at the uinput level.

echo "Releasing stuck keys via ydotool..."

# Space (scancode 57)
ydotool key 57:0
# Left Ctrl (29), Right Ctrl (97)
ydotool key 29:0 97:0
# Left Shift (42), Right Shift (54)
ydotool key 42:0 54:0

echo "Done. Keys should be unstuck."
