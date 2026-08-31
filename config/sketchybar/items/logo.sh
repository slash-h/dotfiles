#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

POPUP_OFF="sketchybar --set logo popup.drawing=off"
POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

logo_config=(
  icon.drawing=off
  background.image="$HOME/.config/sketchybar/images/slashh.png"
  background.image.drawing=on
  background.image.scale=0.07
  background.height=30
  background.drawing=on
  padding_right=2
  label.drawing=off
  click_script="$POPUP_CLICK_SCRIPT"
)

sketchybar --add item logo left \
  --set logo "${logo_config[@]}"

sketchybar --add item apple.prefs popup.logo \
  --set apple.prefs icon=$PREFERENCES \
  label="Preferences" \
  click_script="open -a 'System Preferences';
                $POPUP_OFF"

sketchybar --add item apple.activity popup.logo \
  --set apple.activity icon=$ACTIVITY \
  label="Activity" \
  click_script="open -a 'Activity Monitor';
                $POPUP_OFF"

sketchybar --add item apple.lock popup.logo \
  --set apple.lock icon=$LOCK \
  label="Lock Screen" \
  click_script="pmset displaysleepnow;
                $POPUP_OFF"

# Transparent tray — kept as a container for future grouping (no border, no fill)
logo_tray_config=(
  background.drawing=off
)

sketchybar --add bracket logo_tray logo \
  --set logo_tray "${logo_tray_config[@]}"

# Add empty space after the logo
# sketchybar --add item empty left --set empty icon=' ' label.drawing=off
