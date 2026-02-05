#!/bin/bash
# Mount Proton Drive automatically
MOUNT_DIR="$HOME/Drive"
mkdir -p "$MOUNT_DIR"

# Check if already mounted
if mountpoint -q "$MOUNT_DIR"; then
    echo "Proton Drive is already mounted."
else
    rclone mount Drive: "$MOUNT_DIR" --vfs-cache-mode writes --daemon
    echo "Proton Drive mounted at $MOUNT_DIR"
fi
