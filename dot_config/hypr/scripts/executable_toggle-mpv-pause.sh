#!/bin/bash
# Находим PID процесса mpv (который запущен mpvpaper)
MPV_PID=$(pgrep -x mpv)

if [ -z "$MPV_PID" ]; then
    notify-send -t 1500 "Видеообои" "mpv не запущен"
    exit 1
fi

# Проверяем текущее состояние: T = stopped (приостановлен)
STATE=$(ps -o state= -p "$MPV_PID" | tr -d ' ')
if [[ "$STATE" == "T" ]]; then
    kill -CONT "$MPV_PID"
    notify-send -t 1500 "Видеообои" "Воспроизведение продолжено"
else
    kill -STOP "$MPV_PID"
    notify-send -t 1500 "Видеообои" "Воспроизведение приостановлено"
fi
