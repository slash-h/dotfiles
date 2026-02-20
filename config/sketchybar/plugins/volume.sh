#!/bin/sh

source "$HOME/.config/sketchybar/colors.sh"

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

COLOR=$WHITE
if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  case "$VOLUME" in
  [8-9][0-9] | 100)
    ICON="󰕾"
    COLOR=$RED
    ;;
  [6-7][0-9])
    ICON="󱄠"
    COLOR=$ORANGE
    ;;
  [3-5][0-9])
    ICON="󰖀"
    COLOR=$GREEN
    ;;
  [1-9] | [1-2][0-9])
    ICON="󰕿"
    COLOR=$GREEN
    ;;
  *) ICON="󰖁" ;;
  esac

  sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%" icon.color=$COLOR
fi
