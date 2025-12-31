#!/bin/bash

# If the user mounts /opt/ComfyUI, but their directory doesn't have ComfyUI cloned,
# we're gonna copy the pre-cloned one into the mounted directory.

if [ ! -e /opt/ComfyUI/requirements.txt ]; then
   echo "No ComfyUI detected, copying a built-in (pre-cloned) one..."
   cp -r /opt/ComfyUI-pre-cloned/{.,}* /opt/ComfyUI/
fi
