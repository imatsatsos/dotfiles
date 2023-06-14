#!/bin/bash

# Here live some on-login things I want to be run
# These are: 
# setting touchpad scroll speed, 
# merging .Xresources,
# disabling laptop monitor if an external is connected
# setting BENQ monitor refresh to 100 Hz
# setting gnome text scaling factor to 1 when using an external monitor
# setting touchpad scroll speed
# disabling accel on mouse only

set_touchpad_scrollspeed( ){
	# find touchpad device from xinput
	line="$( xinput | grep -iP '(?=.*DELL)(?=.*Touchpad)' )"
	# save touchpad id to var 'id'
	id=$( echo "$line" | grep -oP 'id=\K\d+' )

	# touchpad scroll speed with id
	xinput set-prop $id "libinput Scrolling Pixel Distance" 50
}

set_mouse_accel( ){
	# find mouse device from xinput
	line="$( xinput | grep -iP '(?=.*G305)(?=.*pointer)' )"

	# save mouse id to var 'id'
	id=$( echo "$line" | grep -oP 'id=\K\d+' )

	# mouse Accel Profile with id
	xinput set-prop $id "libinput Accel Profile Enabled" 0, 1
}

find_laptop_monitor_port() {
    laptop_port=$( xrandr -q | grep 'eDP' | grep -w 'connected' | awk '{print $1}' )
}

find_benq_monitor_port() {
    benq_port=$( xrandr -q | grep 'HDMI' | grep -w 'connected' | awk '{print $1}' )
}

set_benq_refresh() {
    if [[ -z $benq_port ]]; then
        return
    else
        xrandr --output $benq_port --mode 1920x1080 --rate 100
    fi
}

disable_laptop_monitor() {
    if [[ -z $benq_port ]]; then
        return
    else
        xrandr --output $laptop_port --off
    fi
}

toggle_scaling_factor() {
	if [[ $XDG_CURRENT_DESKTOP != "GNOME"  ]]; then
		return
	fi
    if [[ -z $benq_port ]]; then
       gsettings set org.gnome.desktop.interface text-scaling-factor 1.10 
    else
       gsettings set org.gnome.desktop.interface text-scaling-factor 1
    fi
}

#fix_intel_power_mangohud(){
#    sudo chmod o+r /sys/class/powercap/intel-rapl\:0/energy_uj
#}

# main
find_laptop_monitor_port
find_benq_monitor_port
sleep 1

set_touchpad_scrollspeed
set_mouse_accel
xrdb -merge ~/.Xresources
setxkbmap -option caps:escape
toggle_scaling_factor
disable_laptop_monitor
wait
sleep 3
set_benq_refresh
notify-send "onlogin.sh run successfully!"
