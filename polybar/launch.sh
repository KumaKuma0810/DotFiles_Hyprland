#!/usr/bin/env sh

# Terminate already running bar instances
 killall -q polybar

# Wait until the processes have been shut down
# while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
polybar laptop  & polybar monitor 
sleep .1

if ! pgrep -x polybar; then
	polybar laptop  & polybar monitor 
else
	pkill -USR1 polybar
fi

echo "Bars launched..."





#!/bin/bash

# Завершаем запущенные инстансы Polybar
#pkill polybar

# Даем X серверу запуститься
#sleep 1

# Запускаем Polybar на eDP-1 и HDMI-1
#MONITOR=eDP-1 polybar --reload edp &
#MONITOR=HDMI-1 polybar --reload hdmi &

#echo "Polybar запущен на eDP-1 и HDMI-1"

