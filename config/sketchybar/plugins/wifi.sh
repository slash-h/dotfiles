#!/usr/bin/env bash
iface=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
[ -z "$iface" ] && iface="en0"

rx1=$(netstat -ibn | awk -v iface="$iface" '$1==iface {print $7; exit}')
tx1=$(netstat -ibn | awk -v iface="$iface" '$1==iface {print $10; exit}')
sleep 1
rx2=$(netstat -ibn | awk -v iface="$iface" '$1==iface {print $7; exit}')
tx2=$(netstat -ibn | awk -v iface="$iface" '$1==iface {print $10; exit}')

drx=$((rx2 - rx1))
dtx=$((tx2 - tx1))

format_speed() {
  if [ "$1" -gt 1000000 ]; then printf "%.1f MB/s" "$(echo "$1/1000000" | bc -l)"; else printf "%.0f KB/s" "$(echo "$1/1000" | bc -l)"; fi
}

sketchybar --set "$NAME" icon="󰁅" label="$(format_speed $drx) / $(format_speed $dtx)"
