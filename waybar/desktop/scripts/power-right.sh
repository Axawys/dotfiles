#!/bin/sh

state_dir="${XDG_RUNTIME_DIR:-/tmp}/waybar-power-right"
count_file="$state_dir/count"
time_file="$state_dir/time"

mkdir -p "$state_dir"

now=$(date +%s%3N 2>/dev/null)
[ -z "$now" ] && now=$(( $(date +%s) * 1000 ))

last=0
count=0

[ -f "$time_file" ] && last=$(cat "$time_file" 2>/dev/null)
[ -f "$count_file" ] && count=$(cat "$count_file" 2>/dev/null)

[ -z "$last" ] && last=0
[ -z "$count" ] && count=0

delta=$((now - last))

if [ "$delta" -le 700 ]; then
    count=$((count + 1))
else
    count=1
fi

echo "$count" > "$count_file"
echo "$now" > "$time_file"

if [ "$count" -ge 2 ]; then
    echo 0 > "$count_file"
    systemctl reboot
fi