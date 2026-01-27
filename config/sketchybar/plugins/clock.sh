#!/usr/bin/env bash
now=$(date "+%b %e %l:%M %p" | sed 's/^ *//;s/  / /g')
sketchybar --set "$NAME" label="$now"

