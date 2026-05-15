#!/bin/bash
# --- НАСТРОЙКИ (ИЗМЕНИТЕ ЭТИ ПУТИ ПОД СЕБЯ) ---
WALLPAPER_DIR="$HOME/Pictures/wallpapers" # Путь к вашим обоям
INTERVAL=300 # Интервал смены обоев в секундах (300 = 5 минут)
FLAG_FILE="/tmp/smart-wallpaper.pause"
LOCK_FILE="/tmp/smart-wallpaper.lock"

# --- ФУНКЦИИ ---
change_wallpaper() {
    # Получаем случайный файл обоев из указанной директории
    local wallpaper=$(find "$WALLPAPER_DIR" -type f \( -name '*.jpg' -o -name '*.png' -o -name '*.jpeg' \) | shuf -n 1)
    if [[ -n "$wallpaper" ]]; then
        # Устанавливаем обои с помощью swww (или замените на свою любимую утилиту)
        swww img "$wallpaper"
        echo "Wallpaper changed to: $wallpaper"
    else
        echo "No wallpapers found in $WALLPAPER_DIR"
    fi
}

toggle_pause() {
    if [[ -f "$FLAG_FILE" ]]; then
        rm -f "$FLAG_FILE"
        notify-send -t 1500 "Wallpaper" "Resumed"
        echo "Resumed"
    else
        touch "$FLAG_FILE"
        notify-send -t 1500 "Wallpaper" "Paused"
        echo "Paused"
    fi
}

# --- ОСНОВНАЯ ЛОГИКА ---
# Проверяем, не запущен ли уже скрипт
if [[ -f "$LOCK_FILE" ]]; then
    echo "Script is already running."
    exit 1
fi
touch "$LOCK_FILE"

# Обрабатываем сигнал USR1 для переключения паузы
trap toggle_pause SIGUSR1

# Главный цикл
while true; do
    if [[ ! -f "$FLAG_FILE" ]]; then
        change_wallpaper
    fi
    sleep "$INTERVAL"
done

# Эта часть не выполнится, т.к. скрипт бесконечный, но на всякий случай.
rm -f "$LOCK_FILE"
