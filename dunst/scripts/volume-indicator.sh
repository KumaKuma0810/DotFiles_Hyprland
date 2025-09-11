#!/bin/bash

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -1 | tr -d '%')
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [ "$muted" = "yes" ]; then
    icon=" "
elif [ "$volume" -eq 0 ]; then
    icon=""
elif [ "$volume" -le 30 ]; then
    icon=""
elif [ "$volume" -le 70 ]; then
    icon="󰕾"
else
    icon=" "
fi

notify-send -h int:value:"$volume" \
            -h string:x-dunst-stack-tag:volume \
            -u low \
            "$icon Volume: ${volume}%"
