#!/bin/sh

iface="$(ip route 2>/dev/null | awk '/default/ {print $5; exit}')"

if [ -z "$iface" ]; then
    printf "NET --.-M ↓ --.-M ↑\n"
    exit 0
fi

rx1=$(cat "/sys/class/net/$iface/statistics/rx_bytes" 2>/dev/null)
tx1=$(cat "/sys/class/net/$iface/statistics/tx_bytes" 2>/dev/null)
sleep 0.5
rx2=$(cat "/sys/class/net/$iface/statistics/rx_bytes" 2>/dev/null)
tx2=$(cat "/sys/class/net/$iface/statistics/tx_bytes" 2>/dev/null)

[ -z "$rx1" ] && printf "NET --.-M ↓ --.-M ↑\n" && exit 0
[ -z "$tx1" ] && printf "NET --.-M ↓ --.-M ↑\n" && exit 0
[ -z "$rx2" ] && printf "NET --.-M ↓ --.-M ↑\n" && exit 0
[ -z "$tx2" ] && printf "NET --.-M ↓ --.-M ↑\n" && exit 0

rx_rate=$(( (rx2 - rx1) * 2 ))
tx_rate=$(( (tx2 - tx1) * 2 ))

format_rate() {
    bytes="$1"
    awk -v b="$bytes" 'BEGIN {
        if (b >= 1048576)
            printf "%4.1fM", b / 1048576;
        else if (b >= 1024)
            printf "%4.1fK", b / 1024;
        else
            printf "%4dB", b;
    }'
}

rx_fmt="$(format_rate "$rx_rate")"
tx_fmt="$(format_rate "$tx_rate")"

printf "NET %s ↓ %s ↑\n" "$rx_fmt" "$tx_fmt"
