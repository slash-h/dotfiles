#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
PLUGIN_DIR="$CONFIG_DIR/plugins"

SPACES_FONT="Hack Nerd Font:Bold:14.0"

# Clock
POPUP_OFF_CLOCK="sketchybar --set clock popup.drawing=off"

sketchybar --add item clock right \
  --set clock update_freq=60 icon= script="$PLUGIN_DIR/clock.sh" \
  icon.font="$SPACES_FONT" \
  icon.color=$OCCUPIED_ICON \
  label.font="$SPACES_FONT" \
  label.color=$OCCUPIED_ICON \
  popup.align=right \
  click_script="sketchybar --set \$NAME popup.drawing=toggle"

sketchybar --add item clock.date popup.clock \
  --set clock.date \
    icon= \
    icon.font="$SPACES_FONT" \
    icon.color=$BLUE \
    label.font="Hack Nerd Font:Bold:12.0" \
    label.color=$WHITE \
    update_freq=60 \
    script="$PLUGIN_DIR/clock_date.sh"

sketchybar --add item clock.calendar popup.clock \
  --set clock.calendar \
    icon= \
    icon.font="$SPACES_FONT" \
    icon.color=$GREEN \
    label="Calendar" \
    label.font="Hack Nerd Font:Bold:12.0" \
    click_script="open -a Calendar; $POPUP_OFF_CLOCK"

# Volume — inline expanding slider (Felix-style, no popup)
sketchybar --add slider volume.slider right 0 \
  --set volume.slider \
    slider.highlight_color=$BLUE \
    slider.background.color=$BACKGROUND_2 \
    slider.background.height=5 \
    slider.background.corner_radius=3 \
    slider.knob="●" \
    slider.knob.color=$WHITE \
    slider.knob.drawing=off \
    slider.knob.y_offset=1 \
    label.drawing=off \
    icon.drawing=off \
    script="$PLUGIN_DIR/volume_slider.sh" \
  --subscribe volume.slider volume_change mouse.clicked mouse.entered mouse.exited

sketchybar --add item volume right \
  --set volume \
    script="$PLUGIN_DIR/volume.sh" \
    icon.font="$SPACES_FONT" \
    icon.color=$OCCUPIED_ICON \
    label.font="$SPACES_FONT" \
    label.color=$OCCUPIED_ICON \
    click_script="$PLUGIN_DIR/volume_click.sh" \
  --subscribe volume volume_change

# Battery
sketchybar --add item battery right \
  --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
  icon.font="$SPACES_FONT" \
  icon.color=$OCCUPIED_ICON \
  label.font="$SPACES_FONT" \
  label.color=$OCCUPIED_ICON \
  --subscribe battery system_woke power_source_change

# # Notify
# sketchybar --add item notif right \
#   --set notif icon.color=$YELLOW \
#   \
#   icon='󰅸' \
#   padding_left=6 \
#   padding_right=4 \
#   icon.padding_left=8 \
#   icon.padding_right=0 \
#   background.border_width=0 \
#   background.corner_radius=6 \
#   background.height=24 \
#   click_script="osascript -e 'tell application \"System Events\" to click menu bar item 1 of menu bar 1 of application process \"ControlCenter\"'" # background.color=$COLOR_BACKGROUND \

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
