#!/bin/bash

sketchybar --add item chevron left --set chevron icon='' label.drawing=off

front_app=(
  # label.font="$FONT:Black:12.0"
  icon.font="sketchybar-app-font:Regular:16.0"
  icon.background.drawing=on
  # display=active
  script="$PLUGIN_DIR/front_app.sh"
  click_script="open -a 'Mission Control'"
)
sketchybar --add item front_app left \
  --set front_app "${front_app[@]}" \
  --subscribe front_app front_app_switched
