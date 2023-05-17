#!/bin/sh
# Script opens a fzf selection of displays to enable/disable using xrandr

echo "Do you want to 1:enable or 2:disable a display? [1 or 2]"
read -r answer
case $answer in
	1)
		displayON="$( xrandr --query | grep -w connected | awk '{print $1}' | fzf --prompt='Choose display to switch ON: ' --header="DISPLAYS" --info=hidden --header-first --reverse)"
		echo "Switching ON $displayON"
		xrandr --output $displayON --auto
		;;
	
	2)
		display="$( xrandr --listmonitors | fzf --prompt='Choose display to switch OFF: ' --header="DISPLAYS" --info=hidden --header-first --reverse)"
		displayOFF="$( echo $display | awk '{print $2}' | sed 's/^.\{1\}//' )"
		echo "Switching OFF $displayOFF"
		xrandr --output $displayOFF --off
		;;
		
	*)
		;;
esac
