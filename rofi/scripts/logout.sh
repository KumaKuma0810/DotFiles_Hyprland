#!/bin/bash

# Меню с иконками (эмодзи)
options=" Logout\n Reboot\n Shutdown\n Suspend"

# Если у тебя есть установлен шрифт FontAwesome (например, patched Nerd Font), то эти иконки будут отображаться
# Если нет — можно заменить на обычные эмодзи, например:
# options="🔓 Logout\n🔄 Reboot\n⏻ Shutdown\n💤 Suspend"

choice=$(echo -e "$options" | rofi -dmenu -p "Select action:")

case "$choice" in
    *Logout)
        i3-msg exit
        ;;
    *Reboot)
        systemctl reboot
        ;;
    *Shutdown)
        systemctl poweroff
        ;;
    *Suspend)
        systemctl suspend
        ;;
    *)
        exit 0
        ;;
esac


