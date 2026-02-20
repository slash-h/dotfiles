#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

slashh_logo=(
  icon='' #'󰥳' #'󰠩'
  icon.font="Hack Nerd Font:Regular:18.0"
  icon.color=$MAGENTA
  icon.background.height=30
  # icon.background.color=$BLUE
  # icon.background.corner_radius=15
  padding_right=5
  # label.background.drawing=on
  label.drawing=off
)

sketchybar --add item slashh left \
  --set slashh "${slashh_logo[@]}"

# Add tray (bracket) containing all spaces
logo_tray_config=(
  background.color=$BACKGROUND_2
  background.border_color=$MAGENTA
  background.border_width=2
  background.drawing=on
  background.height=30
  background.corner_radius=5
)

sketchybar --add bracket logo_tray slashh \
  --set logo_tray "${logo_tray_config[@]}"

# Add empty space after the logo
sketchybar --add item empty left --set empty icon=' ' label.drawing=off
