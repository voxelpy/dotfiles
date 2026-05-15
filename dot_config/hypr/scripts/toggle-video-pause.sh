#!/bin/bash
SOCKET="/tmp/mpv-video.sock"

if [ ! -e "$SOCKET" ]; then
    notify-send -t 1500 "Видеообои" "Сервер IPC не найден"
    exit 1
fi

# Отправляем команду 'cycle pause' через сокет
echo 'cycle pause' | socat - "$SOCKET" 2>/dev/null

# Проверяем результат
if [ $? -eq 0 ]; then
    notify-send -t 1500 "Видеообои" "Пауза/возобновление"
else
    notify-send -t 1500 "Видеообои" "Ошибка: установите socat"
fi
