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

	## debug
	#echo $line
	#echo $id
	
	# finally set touchpad scroll speed with id
	xinput set-prop $id "libinput Scrolling Pixel Distance" 50
}

set_benq_refresh() {
    # find port benq is connected
    port=$( xrandr -q | grep 'HDMI' | grep -Ev 'disconnected' | awk '{print $1}' )
    # set refresh rate
    xrandr --output $port --mode 1920x1080 --rate 100
}

sleep 1
set_touchpad_scrollspeed
xrdb -merge ~/.Xresources
set_benq_refresh
notify-send "onlogin.sh run successfully!"
