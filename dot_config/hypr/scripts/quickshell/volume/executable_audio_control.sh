#!/bin/bash
case "$1" in
  get-volume)
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
    ;;
  change-volume)
    # $2 — это число (шаг). Увеличиваем или уменьшаем
    if [[ "$2" =~ ^[0-9]+$ ]]; then
      wpctl set-volume @DEFAULT_AUDIO_SINK@ "$2%+"
    else
      # на случай если передаётся +10 или -10
      wpctl set-volume @DEFAULT_AUDIO_SINK@ "$2"
    fi
    ;;
  mute)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    ;;
  get-mute)
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo 1 || echo 0
    ;;
  get-sinks)
    wpctl status | grep -A1 "Sinks:" | tail -n +2 | grep -oP '^\s*\d+\.\s+\K[^[]+' | sed 's/ *$//'
    ;;
  set-sink)
    # $2 — имя устройства
    wpctl set-default "$2"
    ;;
esac
