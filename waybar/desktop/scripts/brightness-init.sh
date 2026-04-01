#!/bin/bash
val=$(ddcutil getvcp 10 2>/dev/null | sed -n 's/.*current value = *\([0-9]\+\).*/\1/p')
[ -n "$val" ] || val=50
mkdir -p "$HOME/.cache"
echo "$val" > "$HOME/.cache/brightness-state"
echo "$val" > "$HOME/.cache/brightness-target"
echo "$val" > "$HOME/.cache/brightness-sent"
pkill -RTMIN+8 waybar >/dev/null 2>&1
