#!/bin/bash

notify() {
    dunstify -r 9527 -u low "🎵 Аудио" "$1"
}

# Получаем все sinks с их описанием и состоянием
# Формат: "Имя_устройства:Описание_устройства"
ALL_SINKS=$(pactl list sinks | grep -E "Name:|Description:" | paste -d ' ' - - | sed 's/Name: //;s/Description: //' | awk -F' ' '{print $1 ":" substr($0, index($0,$2))}')

if [ -z "$ALL_SINKS" ]; then
    notify "❌ Нет доступных устройств вывода"
    exit 1
fi

# Текущее устройство по умолчанию
CURRENT_SINK=$(pactl get-default-sink)

# Формируем список для wofi: показываем только описания
CHOICE=$(echo "$ALL_SINKS" | awk -F: '{print $2}' | wofi --dmenu -p "🎧 Выберите устройство вывода")

if [ -z "$CHOICE" ]; then
    exit 0
fi

# Находим имя устройства по выбранному описанию
SELECTED_SINK=$(echo "$ALL_SINKS" | grep ":$CHOICE$" | awk -F: '{print $1}')

if [ -z "$SELECTED_SINK" ]; then
    notify "❌ Не удалось определить устройство"
    exit 1
fi

# Если выбрано то же устройство — ничего не делаем
if [ "$SELECTED_SINK" = "$CURRENT_SINK" ]; then
    notify "Устройство уже активно: $CHOICE"
    exit 0
fi

# Переключаем
pactl set-default-sink "$SELECTED_SINK"
pactl list short sink-inputs | while read -r stream; do
    streamId=$(echo "$stream" | awk '{print $1}')
    pactl move-sink-input "$streamId" "$SELECTED_SINK"
done

notify "✅ Переключено на: $CHOICE"
