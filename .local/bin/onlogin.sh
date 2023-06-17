#!/bin/bash

# Here are some things I run on login

# setting touchpad scroll speed, 
# merging .Xresources,
# disabling laptop monitor if an external is connected
# setting BENQ monitor refresh to 100 Hz if it is connected
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
    if [ -z "$benq_port" ]; then
        return
    else
        xrandr --output $benq_port --mode 1920x1080 --rate 100
    fi
}

disable_laptop_monitor() {
    if [ -z "$benq_port" ]; then
        return
    else
        xrandr --output $laptop_port --off
    fi
}

gnome_scaling_factor() {
	if [[ $XDG_CURRENT_DESKTOP != "GNOME"  ]]; then
		return
	fi
    if [ -z $benq_port ]; then
       gsettings set org.gnome.desktop.interface text-scaling-factor 1.25 
    else
       gsettings set org.gnome.desktop.interface text-scaling-factor 1
    fi
}

# functions that only have a reason to run on X11 session
on_xorg(){
    if [[ $XDG_SESSION_TYPE != "x11" ]]; then
        return
    else
        xrdb -merge /home/$USER/.Xresources
        find_laptop_monitor_port
        find_benq_monitor_port
        disable_laptop_monitor
        sleep 3
        set_benq_refresh
        set_touchpad_scrollspeed
        set_mouse_accel
    fi
}

#fix_intel_power_mangohud(){
#    sudo chmod o+r /sys/class/powercap/intel-rapl\:0/energy_uj
#}

# main
on_xorg
setxkbmap -option caps:escape
gnome_scaling_factor
notify-send "onlogin.sh success!"
