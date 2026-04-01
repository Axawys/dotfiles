#!/bin/bash

target="$HOME/.cache/brightness-target"
sent="$HOME/.cache/brightness-sent"
lock="/tmp/ddcutil.lock"

mkdir -p "$HOME/.cache"
[ -f "$target" ] || echo 50 > "$target"
[ -f "$sent" ] || echo -1 > "$sent"

while true; do
  want=$(cat "$target" 2>/dev/null)
  last=$(cat "$sent" 2>/dev/null)

  case "$want" in
    ''|*[!0-9]*) sleep 0.15; continue ;;
  esac

  case "$last" in
    ''|*[^0-9-]*) last=-1 ;;
  esac

  if [ "$want" != "$last" ]; then
    if flock -w 2 8; then
      if ddcutil setvcp 10 "$want" >/dev/null 2>&1; then
        echo "$want" > "$sent"
      fi
    fi 8>"$lock"
  fi

  sleep 0.15
done