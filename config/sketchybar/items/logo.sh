#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

POPUP_OFF="sketchybar --set logo popup.drawing=off"
POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

logo_config=(
  icon='' #'󰥳' #'󰠩'
  icon.font="Hack Nerd Font:Regular:18.0"
  icon.color=$MAGENTA
  icon.background.height=30
  # icon.background.color=$BLUE
  # icon.background.corner_radius=15
  padding_right=2
  # label.background.drawing=on
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

# Add tray (bracket) containing all spaces
logo_tray_config=(
  background.color=$BACKGROUND_2
  background.border_color=$MAGENTA
  background.border_width=2
  background.drawing=on
  background.height=30
  background.corner_radius=5
)

sketchybar --add bracket logo_tray logo \
  --set logo_tray "${logo_tray_config[@]}"

# Add empty space after the logo
sketchybar --add item empty left --set empty icon=' ' label.drawing=off
