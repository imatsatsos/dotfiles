#!/bin/sh

/bin/xbps-install --dry-run --update --memory-sync 1>/tmp/updates 2>/tmp/error

updates="$(wc -l < /tmp/updates)"
broken="$(grep broken /tmp/error | wc -l)"
pkg="$(awk '{print $1" ---> "$2}' /tmp/updates)"
pkgs="$(awk '{print $1}' /tmp/updates)"
unresolved="$(grep broken /tmp/error | awk '{ print $1" "$5 }')"
xx=$(printf "=================================================")

if [ "$broken" = 0 ] && [ "$updates" -ge 1 ]; then
	#~/Datos/Git/scripts/varios/dunst_sound.sh
	if [ "$updates" -eq 1 ]; then
		notify-send "UPDATE AVAILABLE:" "$pkg"
	elif [ "$updates" -gt 1 ]; then
		notify-send "UPDATES AVAILABLE: $updates" "$xx $pkgs"
	else
		echo ""
	fi
fi

if [ "$broken" -ge 1 ]; then
	notify-send -u critical "THERE ARE BROKEN PKGS:" "$xx $(cut -d " " -f 1,5 /tmp/error)"
#	notify-send -u critical "THERE ARE BROKEN PKGS:" "$xx $unresolved"
fi
