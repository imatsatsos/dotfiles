#!/bin/bash

# Here are some things I run on login

# Merging .Xresources,
# Disabling laptop monitor if an external is connected
## Setting BENQ monitor refresh to 100 Hz if it is connected
## Setting gnome text scaling factor to 1 when using an external monitor
# Touchpad: set slower scroll speed
# Mouse: disable acceleration
# Bluetooth: disable (soft-block)

gnome_scaling_factor() {
  if [[ $XDG_CURRENT_DESKTOP == "GNOME"  ]]; then
    if [ -z $benq_port ]; then
      gsettings set org.gnome.desktop.interface text-scaling-factor 1.25 
    else
      gsettings set org.gnome.desktop.interface text-scaling-factor 1
    fi
  fi
}

# functions that only have a reason to run on X11 session
on_xorg() {
  if [[ $XDG_SESSION_TYPE == "x11" ]]; then
    dbus-update-activation-environment DISPLAY XAUTHORITY
    xrdb -merge "$HOME/.Xresources"
    #displays   # in development
    fix_input
    xset r rate 280 40
    setxkbmap -model pc105 -layout us,gr -option grp:alt_shift_toggle,caps:escape
  fi
}

on_xorg
#gnome_scaling_factor
rfkill block bluetooth
wpctl set-volume @DEFAULT_SINK@ 50%
wpctl set-volume @DEFAULT_SOURCE@ 16%
# probablye not needed as i start it in my bashprofile
#eval `ssh-agent`

notify-send "Login script run!"

