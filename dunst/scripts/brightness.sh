#!/bin/bash

# Получаем текущую яркость (в процентах)
BRIGHTNESS=$(brightnessctl | grep -oP '\(\K[0-9]+(?=%\))')

# Показываем уведомление через dunst
dunstify -r 9993 -u low "☀ Яркость: $BRIGHTNESS%"

