#!/bin/bash
state="$HOME/.cache/brightness-state"

[ -f "$state" ] || echo 50 > "$state"
val=$(cat "$state" 2>/dev/null)

case "$val" in
  ''|*[!0-9]*) exit 1 ;;
esac

echo "{\"text\":\"BRT ${val}%\",\"percentage\":$val}"