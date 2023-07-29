#!/bin/sh

# Script opens a fzf selection of displays to enable/disable using xrandr

echo "Do you want to 1:Enable or 2:Disable a display or 3:Auto mode?  [1/2/3]"
read -r answer

find_laptop_monitor_port() {
  laptop_port=$( xrandr -q | grep 'eDP' | grep -w 'connected' | awk '{print $1}' )
}

find_benq_monitor_port() {
  benq_port=$( xrandr -q | grep 'HDMI' | grep -w 'connected' | awk '{print $1}' )
}

set_benq_refresh() {
  if [ ! -z "$benq_port" ]; then
    xrandr --output $benq_port --mode 1920x1080 --rate 100
  fi
}

disable_laptop_monitor() {
  if [ ! -z "$benq_port" ]; then
    xrandr --output $laptop_port --off
  fi
}

display="$( xrandr --listmonitors | fzf --prompt='Choose monitor: ' --header="DISPLAYS" --info=hidden --header-first --reverse)"
case $answer in
	1)
		displayON="$( echo "$display" | awk '{print $4}' )"
		echo "Switching ON $displayON"
		xrandr --output "$displayON" --auto
	;;
	
	2)
		displayOFF="$( echo "$display" | awk '{print $4}' )"
		# | sed 's/^.\{1\}//' removes first character
		echo "Switching OFF $displayOFF"
		xrandr --output "$displayOFF" --off
	;;
	3)
		echo "Auto mode in development"
	;;
		
	*)
	;;
esac
