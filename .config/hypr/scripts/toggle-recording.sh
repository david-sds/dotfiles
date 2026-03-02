#!/bin/bash

# Path to save recordings
SAVE_DIR="$HOME/Videos/Recordings"
mkdir -p "$SAVE_DIR"

# File name with timestamp
FILENAME="rec_$(date +%Y-%m-%d_%H-%M-%S).mp4"

# Check if recording is already running
if pgrep -x "wl-screenrec" > /dev/null; then
    pkill -x "wl-screenrec"
    notify-send "Recording Stopped" "Video saved to $SAVE_DIR" -i camera-video
else
    # Select region and start recording
    GEOM=$(slurp)
    if [ -z "$GEOM" ]; then exit 1; ffi

    notify-send "Recording Started" "Select area to begin..." -i camera-video
    wl-screenrec -g "$GEOM" -f "$SAVE_DIR/$FILENAME" &
fi
