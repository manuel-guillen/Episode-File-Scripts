#!/bin/bash

# Check if VLC is installed
if ! which vlc &> /dev/null; then
    echo "VLC is not installed. Please install VLC and try again."
    exit 1
fi

# Assert a single argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

file_path="$1"

# Check if the file exists
if [ ! -f "$file_path" ]; then
    echo "File does not exist: $file_path"
    exit 1
fi

# Open the file in VLC
echo "Opening $file_path in VLC..."
exec vlc --quiet -I rc "$file_path" --sout "#chromecast" --sout-chromecast-ip=$TV_IP --demux-filter=demux_chromecast
