#!/bin/env sh
# I run it on login with a DE/WM

# Disabling laptop monitor if an external is connected
## Setting BENQ monitor refresh to 100 Hz if it is connected

# Setting gnome text scaling factor to 1 when using an external monitor
gnome_scaling_factor() {
  if [ "$XDG_CURRENT_DESKTOP" = "GNOME"  ]; then
    if [ -z "$benq_port" ]; then
      gsettings set org.gnome.desktop.interface text-scaling-factor 1.25 
    else
      gsettings set org.gnome.desktop.interface text-scaling-factor 1
    fi
  fi
}

# Functions that only have a reason to run on X11 session
on_xorg() {
  if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    # Update dbus variables
    dbus-update-activation-environment DISPLAY XAUTHORITY
    # Merge .Xresources,
    xrdb -merge "$HOME/.Xresources"
    
    #displayssetup     # in development
    
    # Set low scroll speed on touchpad, disable mouse acceleration
    fixinput
    # Set repeat delay, repeat rate
    xset r rate 280 40
    # Set keyboard layout and layout switch key
    setxkbmap -model pc105 -layout us,gr -option grp:alt_shift_toggle,caps:escape
  fi
}

on_xorg

# gnome_scaling_factor
## probably not needed as i start it in my bashprofile
# eval `ssh-agent`

# Disable bluetooth (soft-block)
rfkill block bluetooth
# Set default output volume
wpctl set-volume @DEFAULT_SINK@ 50%
# Set default mic volume
wpctl set-volume @DEFAULT_SOURCE@ 16%

notify-send "Login script run!"

