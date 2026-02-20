#!/bin/bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
PLUGIN_DIR="$CONFIG_DIR/plugins"

# Clock
sketchybar --add item clock right \
  --set clock update_freq=60 icon= script="$PLUGIN_DIR/clock.sh"

# Volume
sketchybar --add item volume right \
  --set volume script="$PLUGIN_DIR/volume.sh" \
  --subscribe volume volume_change

#Battery
sketchybar --add item battery right \
  --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
  --subscribe battery system_woke power_source_change

# CPU
# sketchybar --add item cpu right \
#            --set cpu icon= label="--%" update_freq=2 script="$PLUGIN_DIR/cpu.sh" \
#                  background.drawing=off
#
# # Memory
# sketchybar --add item mem right \
#            --set mem icon= label="--%" update_freq=5 script="$PLUGIN_DIR/mem.sh" \
#                  background.drawing=off
#
# # WiFi (Down/Up)
# sketchybar --add item wifi right \
#            --set wifi icon="󰁅" label="-- / --" update_freq=2 script="$PLUGIN_DIR/wifi.sh" \
#                  background.drawing=off
