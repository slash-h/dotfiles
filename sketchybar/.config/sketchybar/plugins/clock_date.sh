#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

full_date=$(date "+%A, %B %-d %Y")
sketchybar --set "$NAME" label="$full_date" icon.color=$BLUE
