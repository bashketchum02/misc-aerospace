#!/usr/bin/env bash

LOCK=/tmp/sketchybar-aerospace.lock
# Recover from stale locks (dirs older than 3s count as stale)
if [[ -d "$LOCK" ]]; then
    [[ -n "$(find "$LOCK" -type d -newermt '-2 seconds' 2>/dev/null)" ]] || rm -rf "$LOCK"
else
    rm -rf "$LOCK"
fi
for i in {1..10}; do
    mkdir "$LOCK" 2>/dev/null && break
    sleep 0.02
done
trap 'rmdir "$LOCK" 2>/dev/null' EXIT

FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
COUNT=$(aerospace list-windows --workspace "$FOCUSED" 2>/dev/null | wc -l | grep -Eo '[0-9]+' | head -1)

space_colors=(
  0xffea6962 0xffe78a4e 0xffd8a657 0xffa9b665 0xff7daea3
  0xff89b482 0xffd3869b 0xffbf6b3f 0xffc57b57
)

set_args=()
for sid in 1 2 3 4 5 6 7 8 9; do
    color=${space_colors[$((sid - 1))]}
    if [[ "$sid" = "$FOCUSED" ]]; then
        set_args+=(--set "space.$sid" background.drawing=on background.color=$color label.color=0xff141414 label="$sid [$COUNT]")
    else
        set_args+=(--set "space.$sid" background.drawing=on background.color=0xff2d2d2d label.color=0x88d4be98 label="$sid")
    fi
done

sketchybar "${set_args[@]}"
