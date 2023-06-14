#!/bin/sh

# Script opens a fzf selection of disk devices to mount as ntfs3

# fzf menu
menu="$( lsblk -lo NAME,FSTYPE,SIZE,FSUSE%,MOUNTPOINTS | fzf --prompt='Choose: ' --header="DISKS" --info=hidden --header-first --reverse)"

# keep first column from selection
device="$( echo "$menu" | awk '{print $1}' )"

# keep second column from selection
device_fs="$( echo $menu | awk '{print $2}' )"

# the path to mount the ntfs drive
mount_path="/media/${device}/"

# check if selection is a partition
if lsblk -lo NAME | awk '!/^[a-z]+$/ && /^[a-z]+[0-9]+$/' | grep -qw $device; then
	# check if selection is a ntfs partition
	case $device_fs in
		"ntfs")
			[ ! -d ${mount_path} ] && sudo mkdir -p ${mount_path}
			sudo mount -t ntfs3 "/dev/${device}" "${mount_path}"
			nohup nautilus ${mount_path} >/dev/null 2>&1 &
		;;
		*)
			echo "This is a $device_fs partition. This tool can't mount it"
		;;
	esac
else
	echo "NOT A VALID DEVICE!"
fi
