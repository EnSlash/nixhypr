#!/bin/sh

# Get the first battery found by upower
battery=$(upower -e | grep 'BAT')

if [ -z "$battery" ]; then
    echo "{\"text\": \"No Bat\", \"tooltip\": \"Battery not found\"}"
    exit 1
fi

# Get battery details
details=$(upower -i "$battery")
state=$(echo "$details" | grep -E "state" | awk '{print $2}')
percentage=$(echo "$details" | grep -E "percentage" | awk '{print $2}' | tr -d '%')
time_to_full=$(echo "$details" | grep -E "time to full" | awk '{print $4, $5}')
time_to_empty=$(echo "$details" | grep -E "time to empty" | awk '{print $4, $5}')

icon=""
if [ "$state" = "charging" ]; then
    icon="⚡"
elif [ "$state" = "fully-charged" ]; then
    icon=""
else
    if [ "$percentage" -le 20 ]; then
        icon=""
    elif [ "$percentage" -le 40 ]; then
        icon=""
    elif [ "$percentage" -le 60 ]; then
        icon=""
    elif [ "$percentage" -le 80 ]; then
        icon=""
    else
        icon=""
    fi
fi

text="$percentage% $icon"
tooltip="State: $state"

if [ "$state" = "charging" ]; then
    tooltip="$tooltip\nTime to full: $time_to_full"
elif [ "$state" = "discharging" ]; then
    tooltip="$tooltip\nTime to empty: $time_to_empty"
fi


printf '{"text": "%s", "tooltip": "%s"}\n' "$text" "$tooltip"
