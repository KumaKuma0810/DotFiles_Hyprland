#!/bin/bash

FILE_HASH=$(echo -n "$file" | md5sum | cut -d ' ' -f1)
COVER_PATH="/tmp/cmus_cover_${FILE_HASH}.jpg"

# Путь к дефолтной обложке
DEFAULT_COVER_PATH="$HOME/.config/dunst/scripts/default-song.png"

# Максимальная длина названия и исполнителя
MAX_TEXT_LENGTH=20

# Время отображения уведомления (в миллисекундах)
NOTIFY_DURATION=5000

# Получаем метаинформацию из cmus
get_metadata() {
    cmus-remote -Q | awk '
        /^tag artist/   { artist = substr($0, index($0,$3)) }
        /^tag title/    { title = substr($0, index($0,$3)) }
        /^file/         { file = substr($0, index($0,$2)) }
        END {
            print artist "|" title "|" file
        }'
}

# Обрезаем строки с многоточием, если длиннее MAX_TEXT_LENGTH
truncate_text() {
    local text="$1"
    if [ "${#text}" -gt "$MAX_TEXT_LENGTH" ]; then
        echo "${text:0:$((MAX_TEXT_LENGTH - 1))}…"
    else
        echo "$text"
    fi
}

# Извлекаем обложку из файла (mp3/flac)
extract_cover() {
    local file="$1"
    rm -f "$COVER_PATH"
    if ffmpeg -i "$file" -an -vcodec copy "$COVER_PATH" -y 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Готовим текст уведомления
prepare_notification_text() {
    local artist="$1"
    local title="$2"
    echo -e "Название: $title\nИсполнитель: $artist"
}

# Отправляем уведомление
send_notification() {
    local cover_path="$1"
    local title="$2"
    local text="$3"

    if [ ! -f "$cover_path" ]; then
        cover_path="$DEFAULT_COVER_PATH"
    fi

    notify-send -i "$cover_path" -h "string:x-dunst-stack-tag:music" -t "$NOTIFY_DURATION" "$title" "$text"
}

main() {
    local metadata
    metadata=$(get_metadata)

    IFS='|' read -r artist title file <<< "$metadata"

    if [ -z "$artist" ] || [ -z "$title" ]; then
        echo "Ошибка: нет информации о текущем треке."
        exit 1
    fi

    # Обрезаем с многоточием
    artist=$(truncate_text "$artist")
    title=$(truncate_text "$title")

    # Генерируем уникальный путь к обложке
    FILE_HASH=$(echo -n "$file" | md5sum | cut -d ' ' -f1)
    COVER_PATH="/tmp/cmus_cover_${FILE_HASH}.jpg"

    # Пытаемся извлечь обложку
    if [ -f "$file" ]; then
        extract_cover "$file" || echo "Обложка не найдена, используется дефолтная."
    fi

    notification_text=$(prepare_notification_text "$artist" "$title")
    send_notification "$COVER_PATH" "$title" "$notification_text"
}


main

