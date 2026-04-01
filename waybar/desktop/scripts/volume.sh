#!/bin/sh

out="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)"

case "$out" in
  *MUTED*|*muted*)
    echo "VOL MUTE"
    exit 0
    ;;
esac

vol="$(printf '%s\n' "$out" | awk '{printf "%d", $2 * 100}')"

echo "VOL ${vol}%"
