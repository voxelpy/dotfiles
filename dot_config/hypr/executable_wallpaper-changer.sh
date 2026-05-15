#!/bin/bash

# ============================================================
#  Видеообои для Hyprland с автоматическим перезапуском
# ============================================================

# --- Настройки ---
WALLPAPER_DIR="$HOME/Videos"
MONITOR="HDMI-A-1"
# Время в секундах, через которое обои будут перезапускаться
# 3600 секунд = 1 час. Ты можешь изменить это значение.
RESTART_INTERVAL=3600

# --- Поиск видео ---
mapfile -t VIDEOS < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mov" -o -iname "*.mkv" \) 2>/dev/null)

if [ ${#VIDEOS[@]} -eq 0 ]; then
    echo "❌ Нет видео в $WALLPAPER_DIR"
    exit 1
fi

# --- Выбор случайного видео ---
RANDOM_VIDEO=$(printf "%s\n" "${VIDEOS[@]}" | shuf -n1)

# --- Убиваем старые процессы ---
killall mpvpaper mpv 2>/dev/null

# --- Запускаем оптимизированный mpvpaper ---
mpvpaper -o "no-audio --loop --hwdec=auto-safe --cache=no --demuxer-max-bytes=10M --vd-lavc-threads=1 --no-demuxer-thread --untimed --video-latency-hacks=yes --vo=gpu" "$MONITOR" "$RANDOM_VIDEO" &

# --- ЗАПУСКАЕМ ПЛАНИРОВЩИК ПЕРЕЗАПУСКА (ВОТ ЭТО ГЛАВНОЕ) ---
(
    sleep $RESTART_INTERVAL
    killall mpvpaper 2>/dev/null
    # Перезапускаем этот же скрипт
    exec "$0"
) &

echo "✅ Запущено видео: $(basename "$RANDOM_VIDEO")"
echo "🔄 Автоматический перезапуск через $((RESTART_INTERVAL / 60)) минут"
