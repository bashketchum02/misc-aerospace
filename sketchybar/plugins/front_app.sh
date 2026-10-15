#!/usr/bin/env bash

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO" label.font.style=italic label.color=0xffd4be98
fi
