#!/bin/sh

# Script opens a fzf selection of displays to enable/disable using xrandr

echo "Do you want to 1:Enable or 2:Disable a display?  [1/2]"
read -r answer

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
		
	*)
	;;
esac
