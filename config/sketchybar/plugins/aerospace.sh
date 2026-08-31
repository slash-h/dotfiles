#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

source "$HOME/.config/sketchybar/colors.sh"
AEROSPACE_BIN="/opt/homebrew/bin/aerospace"

# FOCUSED_WORKSPACE is set by aerospace_workspace_change; for other events (e.g.
# front_app_switched) query aerospace directly so window-state updates still work.
focused="${FOCUSED_WORKSPACE:-$("$AEROSPACE_BIN" list-workspaces --focused 2>/dev/null)}"

if [ "$1" = "$focused" ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.color=$ACTIVE_BG \
    background.height=4 \
    background.corner_radius=2 \
    background.y_offset=-13 \
    background.border_width=0 \
    icon.color=$WHITE
else
  if [ -n "$("$AEROSPACE_BIN" list-windows --workspace "$1" 2>/dev/null)" ]; then
    icon_color=$OCCUPIED_ICON
  else
    icon_color=$INACTIVE_ICON
  fi
  sketchybar --set "$NAME" \
    background.drawing=off \
    background.border_width=0 \
    icon.color=$icon_color
fi
