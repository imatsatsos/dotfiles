## Get the aliases and functions
[ -f "$HOME"/.bashrc ] && . "$HOME"/.bashrc

## Environment variables
#export SSH_AUTH_SOCK=run/user/$(id -u)/keyring/ssh
# this one fixes apps that use egl from slow behaviour, seems to break mpv :(
#if /home/$USER/.local/bin/envycontrol.py -q | grep -q integrated ; then
#    export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
#fi

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

if [ -e /home/john/.nix-profile/etc/profile.d/nix.sh ]; then . /home/john/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
