#!/bin/bash

# Настройки
BATTERY="/sys/class/power_supply/BAT0"
CAPACITY=$(cat "$BATTERY/capacity")
STATUS=$(cat "$BATTERY/status")
#!/bin/bash

BATTERY="/sys/class/power_supply/BAT0"
CAPACITY=$(< "$BATTERY/capacity")
STATUS=$(< "$BATTERY/status")

LOW=20
CRITICAL=10
FULL=95

case "$STATUS" in
    Discharging)
        if (( CAPACITY <= CRITICAL )); then
            dunstify -u critical "Батарея почти разряжена ($CAPACITY%)" "Подключи зарядку срочно!"
        elif (( CAPACITY <= LOW )); then
            dunstify -u normal "Низкий заряд ($CAPACITY%)" "Лучше воткнуть зарядку"
        fi
        ;;
    Charging)
        if (( CAPACITY >= FULL )); then
            dunstify -u low "Батарея заряжена ($CAPACITY%)" "Можно отключить зарядку"
        fi
        ;;
    Full)
        dunstify -u low "Батарея полностью заряжена" "Можно отключить зарядку"
        ;;
esac

