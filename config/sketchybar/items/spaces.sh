#!/bin/bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
ITEM_DIR="$CONFIG_DIR/items"
PLUGIN_DIR="$CONFIG_DIR/plugins"
AEROSPACE_BIN="/opt/homebrew/bin/aerospace"

source "$CONFIG_DIR/colors.sh"

# AeroSpace Workspaces
sketchybar --add event aerospace_workspace_change

WORKSPACES=$("$AEROSPACE_BIN" list-workspaces --all 2>/dev/null)

#Add workspaces to all monitors
for monitor in $(aerospace list-monitors --format "%{monitor-appkit-nsscreen-screens-id}"); do
  for sid in $WORKSPACES; do
    #[[------- without app icons  ------ #
    sketchybar --add item space.$sid left \
      --subscribe space.$sid aerospace_workspace_change \
      --set space.$sid \ #background.color=$BACKGROUND_1 \
      icon="$sid" \
      icon.padding_left=10 \
      icon.padding_right=10 \
      padding_left=2 \
      padding_right=2 \
      label.padding_right=20 \
      icon.highlight_color=$RED \
      label.font="sketchybar-app-font:Regular:16.0" \
      label.background.height=26 \
      label.background.drawing=on \
      label.background.color=$BACKGROUND_2 \
      label.background.corner_radius=8 \
      label.drawing=off \
      background.corner_radius=5 \
      click_script="$AEROSPACE_BIN workspace $sid" \
      script="$PLUGIN_DIR/aerospace.sh $sid"
    #]]

    #[[------- with app icons  ------ #
    # sketchybar --add item space.$sid left \
    #   --set space.$sid display="$display_id" \
    #   --subscribe space.$sid aerospace_workspace_change \
    #   --set space.$sid \
    #   drawing=on \
    #   background.color=0x00000000 \
    #   background.corner_radius=2 \
    #   background.drawing=on \
    #   background.border_color=0xAAFFFFFF \
    #   background.border_width=0 \
    #   background.height=25 \
    #   icon="$sid" \
    #   icon.padding_left=10 \
    #   label.font="sketchybar-app-font:Regular:14.0" \
    #   label.padding_right=20 \
    #   label.padding_left=0 \
    #   label.y_offset=-1 \
    #   label.shadow.drawing=off \
    #   click_script="$AEROSPACE_BIN workspace $sid" \
    #   script="$PLUGIN_DIR/aerospace.sh $sid"
    #]]
  done
done

# Add tray (bracket) containing all spaces
spaces=(
  background.color=$BACKGROUND_2
  background.border_color=$MAGENTA
  background.border_width=2
  background.drawing=on
  background.height=30
  background.corner_radius=5
)

sketchybar --add bracket spaces '/space\..*/' \
  --set spaces "${spaces[@]}"
