#!/usr/bin/env bash

# Next event from macOS Calendar via icalBuddy.
# Looks at the next 24 hours; prefix shows "today" or "tmrw".

NEXT=$(icalBuddy \
  --includeEventOnly \
  --includeOnlyEventsFromNowOn \
  --limit 1 \
  --noPropsters \
  --excludeAllDayEvents \
  --dateFormat '%H:%M' \
  --timeFormat '%H:%M' \
  --bullet '' \
  --separateByDate '' \
  eventsFrom:'now' to:'today+1' 2>/dev/null)

if [[ -z "$NEXT" ]]; then
  sketchybar --set "$NAME" icon="󰃭" label="no meetings"
  exit 0
fi

TIME=$(echo "$NEXT" | grep -Eo '[0-9]{2}:[0-9]{2}' | head -1)

# icalBuddy prints the date line ("today:", "tomorrow:") before the event
# when the event lands on a later day.
if echo "$NEXT" | grep -qi 'tomorrow'; then
  PREFIX="tmrw"
else
  PREFIX="today"
fi

# icalBuddy output looks like: "Meeting Title • 14:00"
TITLE=$(echo "$NEXT" | sed -E 's/ \• [0-9]{2}:[0-9]{2}.*//' | sed -E 's/^[[:space:]]*//' | cut -c1-30)

sketchybar --set "$NAME" icon="󰃭" icon.color=0xff141414 label="$PREFIX $TIME $TITLE"
