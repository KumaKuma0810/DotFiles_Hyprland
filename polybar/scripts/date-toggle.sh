#!/usr/bin/env bash

STATEFILE="/tmp/polybar-date-mode"

# Если аргумент toggle — переключаем режим
if [[ "$1" == "toggle" ]]; then
  if [[ -f "$STATEFILE" && "$(cat "$STATEFILE")" == "full" ]]; then
    echo "time" > "$STATEFILE"
  else
    echo "full" > "$STATEFILE"
  fi
  exit 0
fi

# Если файла нет — создаём с дефолтным режимом
[[ ! -f "$STATEFILE" ]] && echo "time" > "$STATEFILE"

MODE=$(cat "$STATEFILE")

if [[ "$MODE" == "full" ]]; then
  # Показываем дату полностью
  date '+ %d %B %Y'
else
  # Показываем только время
  date '+%H:%M'
fi

