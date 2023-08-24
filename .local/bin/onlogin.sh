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
    
    #displayssetup     # in development
    
    # Set low scroll speed on touchpad, disable mouse acceleration
    fixinput
    # Set repeat delay, repeat rate
    xset r rate 280 40
    # Set keyboard layout and layout switch key
    setxkbmap -model pc105 -layout us,gr -option grp:alt_shift_toggle,caps:escapegrp_led:caps
  fi
}

dpi_set() {
  MONITOR="HDMI1"
  dpi=120

  HDMI_STATUS=$(xrandr | grep "${MONITOR} connected")
  if [ -n "${HDMI_STATUS}" ]; then
    dpi=96
  fi

  "$HOME"/.local/bin/change_dpi ${dpi}
}

# run apps for X11 sessions
on_xorg

# Set dpi based on external monitor
dpi_set

# Fix mouse and touchpad input
fixinput
# gnome_scaling_factor

# Update dbus stuff ffs
dbus-update-activation-environment DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# Disable bluetooth (soft-block)
rfkill block bluetooth

# Set default output volume
wpctl set-volume @DEFAULT_SINK@ 50%

# Set default mic volume
wpctl set-volume @DEFAULT_SOURCE@ 16%

notify-send "Login script run!"

