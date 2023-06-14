#!/bin/sh

# Script opens a fzf selection of displays to enable/disable using xrandr

echo "Do you want to 1:Enable or 2:Disable a display?  [1/2]"
read -r answer
case $answer in
	1)
		display="$( xrandr --query | grep -w connected | fzf --prompt='Choose display to switch ON: ' --header="DISPLAYS" --info=hidden --header-first --reverse)"
		displayON="$( echo $display | awk '{print $1}' )"
		echo "Switching ON $displayON"
		xrandr --output $displayON --auto
		;;
	
	2)
		display="$( xrandr --listmonitors | fzf --prompt='Choose display to switch OFF: ' --header="DISPLAYS" --info=hidden --header-first --reverse)"
		displayOFF="$( echo $display | awk '{print $4}' )"
		# | sed 's/^.\{1\}//' removes first character
		echo "Switching OFF $displayOFF"
		xrandr --output $displayOFF --off
		;;
		
	*)
		;;
esac
