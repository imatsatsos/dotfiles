#!/bin/sh

# Script to enable or disable the NVIDIA card on user input.

move_rules_file() {
	if [ -f /etc/udev/rules.d/00-remove-nvidia.rules ]; then
		sudo mv /etc/udev/rules.d/00-remove-nvidia.rules ~/.config/
		echo "AUTO: Switching ON NVIDIA.."
		echo "-- A REBOOT IS REQUIRED TO COMPLETE THE PROCESS --"
	elif [ -f ~/.config/00-remove-nvidia.rules ]; then
		sudo mv ~/.config/00-remove-nvidia.rules /etc/udev/rules.d/
		echo "AUTO: Switching OFF NVIDIA.."
		echo "-- A REBOOT IS REQUIRED TO COMPLETE THE PROCESS --"
	else
		echo "!!! The udev rules file was not found !!!"
	fi
}

echo "Do you want to 1:enable or 2:disable NVIDIA or 3:AUTO?  [1/2/3]"
read -r answer

case $answer in
	1)
		echo "Switching ON NVIDIA.."
		if [ -f /etc/udev/rules.d/00-remove-nvidia.rules ]; then
			sudo mv /etc/udev/rules.d/00-remove-nvidia.rules ~/.config/
			echo "-- A REBOOT IS REQUIRED TO COMPLETE THE PROCESS --"
		elif [ -f ~/.config/00-remove-nvidia.rules ]; then
			echo "NVIDIA is already enabled"
		else
			echo "!!! The udev rules file was not found !!!"
		fi
		;;
	
	2)
		echo "Switching OFF NVIDIA.."
		if [ -f ~/.config/00-remove-nvidia.rules ]; then
			sudo mv ~/.config/00-remove-nvidia.rules /etc/udev/rules.d/
			echo "-- A REBOOT IS REQUIRED TO COMPLETE THE PROCESS --"
		elif [ -f /etc/udev/rules.d/00-remove-nvidia.rules ]; then
			echo "NVIDIA is already disabled"
		else
			echo "!!! The udev rules file was not found !!!"
		fi
		;;
	3)
		move_rules_file
		;;
	*)
		;;
esac

