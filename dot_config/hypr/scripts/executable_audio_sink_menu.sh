#!/bin/bash

# Функция для отправки уведомлений
notify() {
    dunstify -r 9527 -u low "🎵 Аудио" "$1"
}

# Получить список устройств (sinks) в удобном формате
SINKS=$(pactl list short sinks | awk '{print $2}')
# Получить текущее устройство по умолчанию
CURRENT_SINK=$(pactl get-default-sink)

# С помощью dmenu создаем меню для выбора устройства
SELECTED_SINK=$(echo "$SINKS" | dmenu -p "🎧 Выберите устройство вывода:")

# Если пользователь ничего не выбрал — выходим
if [ -z "$SELECTED_SINK" ]; then
    exit 0
fi

# Если выбрано то же устройство, что и текущее — не делаем ничего
if [ "$SELECTED_SINK" = "$CURRENT_SINK" ]; then
    notify "Устройство не изменено: $SELECTED_SINK"
    exit 0
fi

# Устанавливаем новое устройство по умолчанию
pactl set-default-sink "$SELECTED_SINK"

# Перемещаем все текущие аудиопотоки на новое устройство
pactl list short sink-inputs | while read -r stream; do
    streamId=$(echo "$stream" | cut '-d ' -f1)
    pactl move-sink-input "$streamId" "$SELECTED_SINK"
done

notify "✅ Переключено на: $SELECTED_SINK"
