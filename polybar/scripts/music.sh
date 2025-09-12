#!/bin/bash

# ========== НАСТРОЙКИ ==========
MAX_LENGTH=40
ICON_PLAY="  "
ICON_PAUSE="  "
ICON_STOP="  "
ICON_NEXT="  "
ICON_PREV="  "

# ========== ФУНКЦИЯ: сокращение строки ==========
shorten() {
    local input="$1"
    [[ ${#input} -gt $MAX_LENGTH ]] && input="${input:0:$MAX_LENGTH}…"
    echo "$input"
}
# ==========  cmus ==========
if cmus-remote -Q &>/dev/null; then
    STATUS=$(cmus-remote -Q | awk '/^status /{print $2}')
    ARTIST=$(cmus-remote -Q | awk -F ' ' '/^tag artist /{print substr($0, index($0,$3))}')
    TITLE=$(cmus-remote -Q | awk -F ' ' '/^tag title /{print substr($0, index($0,$3))}')

    [[ -n "$ARTIST" || -n "$TITLE" ]] && META="$ARTIST - $TITLE" || META=""

    META=$(shorten "$META")

    case "$STATUS" in
        playing) ICON="$ICON_PLAY" ;;
        paused)  ICON="$ICON_PAUSE" ;;
        stopped) ICON="$ICON_STOP" ;;
        *)       exit 0 ;;
    esac

    echo "%{A1:cmus-remote --prev:}$ICON_PREV%{A} %{A1:cmus-remote --pause:}$ICON%{A} %{A1:cmus-remote --next:}$ICON_NEXT%{A}  $META"
    exit 0
fi

# ========== MPD (ncmpcpp/mpc) ==========
if mpc status &>/dev/null; then
    STATUS=$(mpc status | awk 'NR==2 {print $1}')
    SONG=$(mpc current)

    if [[ -n "$SONG" ]]; then
        if [[ "$SONG" == *" - "* ]]; then
            IFS=' - ' read -r ARTIST TITLE <<< "$SONG"
        else
            ARTIST=""
            TITLE="$SONG"
        fi

        [[ -n "$ARTIST" ]] && META="$ARTIST - $TITLE" || META="$TITLE"
        META=$(shorten "$META")

        case "$STATUS" in
            "[playing]") ICON="$ICON_PLAY" ;;
            "[paused]")  ICON="$ICON_PAUSE" ;;
            *)           ICON="$ICON_STOP" ;;
        esac

        echo "%{A1:mpc prev:}$ICON_PREV%{A} %{A1:mpc toggle:}$ICON%{A} %{A1:mpc next:}$ICON_NEXT%{A}  $META"
        exit 0
    fi
fi

# ========== 4. Ничего не играет ==========
echo "" 
exit 0

