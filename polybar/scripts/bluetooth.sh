#!/bin/bash

ICON_ON="󰂯"
ICON_OFF="󰂲"
ICON_CONNECTED=" "

# Проверка включён ли Bluetooth
if ! bluetoothctl show | grep -q "Powered: yes"; then
  echo "$ICON_OFF"
  exit 0
fi

# Получаем список устройств с их статусом
devices=$(bluetoothctl devices)

# Ищем подключённые устройства
connected_devices=""
while read -r line; do
  device_mac=$(echo "$line" | awk '{print $2}')
  device_name=$(echo "$line" | cut -d' ' -f3-)
  
  # Проверяем статус подключения этого устройства
  if bluetoothctl info "$device_mac" | grep -q "Connected: yes"; then
    connected_devices+="$device_name "
  fi
done <<< "$devices"

# Удаляем лишние пробелы
connected_devices=$(echo "$connected_devices" | xargs)

if [[ -z "$connected_devices" ]]; then
  # Нет подключённых устройств, показываем иконку включенного Bluetooth без устройств
  echo "$ICON_ON"
else
  # Есть подключённые устройства, показываем их список
  echo "$ICON_CONNECTED $connected_devices"
fi
