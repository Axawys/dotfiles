#!/bin/bash

step=2
state="$HOME/.cache/brightness-state"
target="$HOME/.cache/brightness-target"
lock="/tmp/brightness-ui.lock"

mkdir -p "$HOME/.cache"
[ -f "$state" ] || echo 50 > "$state"

exec 9>"$lock"
flock -x 9

current=$(cat "$state" 2>/dev/null)
case "$current" in
  ''|*[!0-9]*) current=50 ;;
esac

case "$1" in
  up)   new=$((current + step)) ;;
  down) new=$((current - step)) ;;
  *) exit 1 ;;
esac

[ "$new" -gt 100 ] && new=100
[ "$new" -lt 0 ] && new=0

echo "$new" > "$state"
echo "$new" > "$target"

pkill -RTMIN+8 waybar >/dev/null 2>&1