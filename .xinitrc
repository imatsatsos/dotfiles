userresources=$HOME/.Xresources
sysresources=/etc/X11/xinit/.Xresources

# merge in defaults

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# set X11 screen resolution
xrandr -s 1920x1080

# set some X11 env variables
export XDG_SESSION_TYPE="x11"

## start window-manager
#exec dbus-run-session /usr/local/bin/dwm
exec dbus-run-session /usr/bin/i3
