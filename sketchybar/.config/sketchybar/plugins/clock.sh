#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

now=$(date "+%b %e %l:%M %p" | sed 's/^ *//;s/  / /g')
sketchybar --set "$NAME" label="$now" icon.color=$BLUE
