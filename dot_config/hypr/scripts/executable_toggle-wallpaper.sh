#!/bin/bash
PID_FILE="/tmp/wallpaper-changer.pid"
PROC_NAMES="random-wallpaper.sh|wallpaper-changer.sh"

if pgrep -f "$PROC_NAMES" > /dev/null; then
    # Скрипты работают → убиваем их и запоминаем, что были запущены
    pkill -f "$PROC_NAMES"
    echo "paused" > "$PID_FILE"
    notify-send -t 1500 "Обои" "Смена обоев остановлена (память освобождена)"
else
    # Скрипты не работают → запускаем заново
    if [ -f "$PID_FILE" ] && grep -q "paused" "$PID_FILE"; then
        # Запускаем те же самые скрипты, что и при старте Hyprland
        ~/.local/bin/random-wallpaper.sh &
        ~/.config/hypr/wallpaper-changer.sh &
        rm "$PID_FILE"
        notify-send -t 1500 "Обои" "Смена обоев возобновлена"
    else
        notify-send -t 1500 "Обои" "Нет скриптов для запуска"
    fi
fi
