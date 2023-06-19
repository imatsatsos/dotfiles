# .bash_profile

## Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

## Environment variables
# this one fixes apps that use egl from slow behaviour
#if /home/$USER/.local/bin/envycontrol.py -q | grep -q integrated ; then
#    export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
#fi

#if NVIDIA
#export LIBVA_DRIVER_NAME=nvidia
#export VDPAU_DRIVER=nvidia
#fi

# WILL NOT WORK HERE
#  because there is no wayland session running yet
#  must be moved after starting wayland compositor below
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
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
fi

## startx
# If DISPLAY=0 and TTY=1 then startx
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    
    ## Uncomment only ONE
    #exec dbus-launch --sh-syntax --exit-with-session sway
    startx
    
    # When startx exits then logout
    logout
fi
