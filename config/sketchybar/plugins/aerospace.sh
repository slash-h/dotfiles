#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

source "$HOME/.config/sketchybar/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.drawing=on \
    \
    background.border_color=$MAGENTA \
    background.border_width=2 \
    background.height=25 #background.color=$BACKGROUND_1
else
  sketchybar --set $NAME background.drawing=off background.border_width=1
fi
