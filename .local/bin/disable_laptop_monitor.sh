#!/bin/bash
#
# Disables laptop monitor if an external monitor is connected

laptop_port=$( xrandr -q | grep 'eDP' | grep -w 'connected' | awk '{print $1}' )

benq_port=$( xrandr -q | grep 'HDMI' | grep -w 'connected' | awk '{print $1}' )

if [[ -z "$benq_port" ]]; then
    exit 1
else
    xrandr --output "$laptop_port" --off
fi

