# .bash_profile

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

# Testing envirnment variables
# this one fixes apps that use egl from slow behaviour
if /home/$USER/.local/bin/envycontrol.py -q | grep -q integrated ; then
    export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50-mesa.json
fi

# If DISPLAY=0 and TTY=1 then startx
# When startx exits then logout
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    startx
    logout
fi
