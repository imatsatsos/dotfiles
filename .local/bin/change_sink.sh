#!/bin/bash
#
# This script will cycle through available output sinks

set -e

default_sink=$(pactl info | grep "Default Sink:" | cut '-d ' -f3)
echo "Current sink: $default_sink"
sinks=$(pactl list short sinks | cut -f2)
echo "Sinks detected: $sinks"

# for wrap-around
sinks="$sinks
$sinks"

next_sink=$(echo "$sinks" | awk "/$default_sink/{getline x;print x;exit;}")
echo "Setting next sink: $next_sink"

pactl set-default-sink "$next_sink"
pactl list short sink-inputs | \
  cut -f1 | \
  xargs -I{} pactl move-sink-input {} "$next_sink"
