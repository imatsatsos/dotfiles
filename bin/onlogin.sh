#!/bin/bash

# Here live some on-login things I want to be run
# These are: setting touchpad scroll speed, merging .Xresources

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

sleep 1
set_touchpad_scrollspeed
xrdb -merge ~/.Xresources
notify-send "onlogin.sh run successfully!"
