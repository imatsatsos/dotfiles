#!/bin/bash
#
# Disables laptop monitor if an external monitor is connected

find_laptop_monitor_port() {
    laptop_port=$( xrandr -q | grep 'eDP' | grep -w 'connected' | awk '{print $1}' )
}

find_benq_monitor_port() {
    benq_port=$( xrandr -q | grep 'HDMI' | grep -w 'connected' | awk '{print $1}' )
}

disable_laptop_monitor() {
    if [[ -z $benq_port ]]; then
        exit 1
    else
        xrandr --output $laptop_port --off
    fi
}

find_laptop_monitor_port
find_benq_monitor_port
disable_laptop_monitor
