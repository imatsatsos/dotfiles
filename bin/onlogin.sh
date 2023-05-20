#!/bin/bash

# Here live some on-login things I want to be run
# These are: 
# setting touchpad scroll speed, 
# merging .Xresources,
# setting BENQ monitor refresh to 100 Hz

set_touchpad_scrollspeed( ){
	# find touchpad device from xinput
	line="$( xinput | grep -iP '(?=.*DELL)(?=.*Touchpad)' )"
	# save touchpad id to var 'id'
	id=$( echo "$line" | grep -oP 'id=\K\d+' )

	# touchpad scroll speed with id
	xinput set-prop $id "libinput Scrolling Pixel Distance" 50
}

set_benq_refresh() {
    # find port benq is connected
    benq_port=$( xrandr -q | grep 'HDMI' | grep -Ev 'disconnected' | awk '{print $1}' )
    # set refresh rate
    xrandr --output $benq_port --mode 1920x1080 --rate 100
}

sleep 1
set_touchpad_scrollspeed
xrdb -merge ~/.Xresources
sleep 2
set_benq_refresh
source ./disable_laptop_monitor.sh
notify-send "onlogin.sh run successfully!"
