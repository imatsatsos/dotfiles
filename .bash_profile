## Get the aliases and functions
[ -f "$HOME"/.bashrc ] && . "$HOME"/.bashrc

#  ___ _  ___   __ __   ___   ___  ___ 
# | __| \| \ \ / / \ \ / /_\ | _ \/ __|
# | _|| .` |\ V /   \ V / _ \|   /\__ \
# |___|_|\_| \_/     \_/_/ \_\_|_\|___/

# PATH
if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin/:$PATH"
fi
# Flatpaks to PATH
if [ -d "/var/lib/flatpak/exports/bin/" ]; then
	PATH="/var/lib/flatpak/exports/bin/:$PATH"
fi
# AppImages to PATH
if [ -d "$HOME/Applications" ]; then
	PATH="$HOME/Applications/:$PATH"
fi
export PATH

# ENVIRONMENT VARIABLES
export EDITOR=nvim
export TERMINAL=st
export BROWSER=runbrave
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export HISTFILE="${XDG_STATE_HOME}"/bash_history
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export LESSHISTFILE=-

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# This fixes apps that use egl from slow behaviour, seems to break mpv :(
#  More test needed..
#if /home/$USER/.local/bin/envycontrol.py -q | grep -q integrated ; then
#    export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
#fi

# Hardware accel for NVIDIA?
#if NVIDIA
#export LIBVA_DRIVER_NAME=nvidia
#export VDPAU_DRIVER=nvidia
#fi

set_wayland() {
    export XDG_SESSION_TYPE="wayland"
    export WLR_RENDERER="vulkan"
     # QT settings
    export QT_QPA_PLATFORM="wayland"
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
     # Firefox settings
    export MOZ_ENABLE_WAYLAND=1
    export MOZ_USE_XINPUT2=1
     # Nvidia settings
    export WLR_NO_HARDWARE_CURSORS=1
    export XWAYLAND_NO_GLAMOR=1
    export GBM_BACKEND="nvidia-drm"
    export __GL_SYNC_ALLOWED=0
    export __GLX_VENDOR_LIBRARY_NAME="nvidia"
    export __EGL_VENDOR_LIBRARY_FILENAMES="/usr/share/glvnd/egl_vendor.d/50_mesa.json"
    export __VK_LAYER_NV_optimus="NVIDIA_only"
}

# ssh-agent
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval $(ssh-agent)
fi

# NIX
if [ -e "$HOME"/.nix-profile/etc/profile.d/nix.sh ]; then . "$HOME"/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

#    _  _   _ _____ ___    ___ _____ _   ___ _______  __
#   /_\| | | |_   _/ _ \  / __|_   _/_\ | _ \_   _\ \/ /
#  / _ \ |_| | | || (_) | \__ \ | |/ _ \|   / | |  >  < 
# /_/ \_\___/  |_| \___/  |___/ |_/_/ \_\_|_\ |_| /_/\_\
                                                      
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    ### Uncomment only ONE
    
    ## WAYLAND
    #pgrep -x sway || exec dbus-run-session /usr/bin/sway
    
    ## X11
    startx
    
    # When WM exits, logout
    logout
fi

