userresources=$HOME/.Xresources
sysresources=/etc/X11/xinit/.Xresources

# merge in defaults
[ -f "$sysresources" ] && xrdb -merge $sysresources
[ -f "$userresources" ]  &&  xrdb -merge "$userresources"

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# source xprofile
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

# set X11 screen resolution
xrandr -s 1920x1080

# set some X11 env variables
export XDG_SESSION_TYPE="x11"

# update dbus environment variables
dbus-update-activation-environment DISPLAY XAUTHORITY

# WM apps
pidof -sx "pipewire" || pipewire &
pidof -sx "pipewire-pulse" || pipewire-pulse &
gnome-keyring-daemon --start --components=secrets,pkcs11 &
pidof -sx "polkit-gnome-authentication-agent-1" || "/usr/libexec/polkit-gnome-authentication-agent-1" &
pidof -sx "dwmblocks" || dwmblocks -b &
pidof -sx "sxhkd" || sxhkd &
pidof -sx "low_battery" || low_battery &
pidof -sx "picom" || picom -b &
xwallpaper --maximize ~/.config/background &
pidof -sx "onlogin.sh" || onlogin.sh &

#autostart="programs"
#for program in $autostart; do
#	pidof -sx "$program" || "$program" &
#done >/dev/null 2>&1

## start window-manager
exec dbus-run-session /usr/local/bin/dwm
#exec dbus-run-session /usr/bin/i3
