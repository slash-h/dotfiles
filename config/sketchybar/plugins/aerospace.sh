#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.color=0xff2a283e icon.shadow.drawing=off background.border_width=3
else
  sketchybar --set $NAME background.color=0x00000000 icon.shadow.drawing=off background.border_width=1
fi
