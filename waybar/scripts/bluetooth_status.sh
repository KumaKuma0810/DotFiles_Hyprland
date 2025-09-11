#!/bin/bash

# Проверяем, включен ли сервис Bluetooth
if ! systemctl is-active --quiet bluetooth; then
    echo " Bluetooth Off"
    exit 0
fi

# Если Bluetooth включен, выводим иконку и сообщение
device=$(bluetoothctl devices | grep "Device" | awk '{print $3}')
if [ -z "$device" ]; then
    echo " Bluetooth On (No device)"
else
    device_name=$(bluetoothctl info $device | grep "Name" | cut -d' ' -f2-)
    echo " Bluetooth On - $device_name"
fi

