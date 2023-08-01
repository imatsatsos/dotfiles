#!/usr/bin/env bash
#
# Scripts displays a fzf menu of configs to edit
# DEPENDS: fzf, vim

declare -A list
list[alacritty]="$HOME/.config/alacritty/alacritty.yml"
list[alacritty_color]="$HOME/.config/alacritty/alacritty_color.yml"
list[alacritty_font]="$HOME/.config/alacritty/alacritty_font.yml"
list[bashrc]="$HOME/.bashrc"
list[fastfetch]="$HOME/.config/fastfetch/config.conf"
list[fontconfig]="$HOME/.config/fontconfig/fonts.conf"
list[git]="$HOME/.config/git/config"
list[inputrc]="$HOME/.inputrc"
list[mpv]="$HOME/.config/mpv/mpv.conf"
list[neofetch]="$HOME/.config/neofetch/config.conf"
list[starship]="$HOME/.config/starship.toml"
list[neovim]="$HOME/.config/nvim/init.lua"
list[ssh]="$HOME/.ssh/config"
list[Xresources]="$HOME/.Xresources"
list[i3-config]="$HOME/.config/i3/config"
list[i3-blocks]="$HOME/.config/i3/i3blocks.conf"
list[i3-window-titles]="$HOME/.config/window_titles.yml"
list[mangohud]="$HOME/.config/MangoHud/MangoHud.conf"
list[dunst]="$HOME/.config/dunst/dunstrc"
list[picom]="$HOME/.config/picom/picom.conf"
list[sway]="$HOME/.config/sway/config"
list[polybar]="$HOME/.config/polybar/config.ini"
list[sxhkdrc]="$HOME/.config/sxhkd/sxhkdrc"

FMENU="fzf --border=rounded --margin=5% --color=dark --height 100% --reverse --header=$(basename "$0") --info=hidden --header-first --prompt"
#FTERM="xst -g=89x32"
FEDITOR="vim"

 # Piping the above array (cleaned) into fzf.
 # We use "printf '%s\n'" to format the array one item to a line.
choice=$(printf '%s\n' "${!list[@]}" | sort | ${FMENU} 'Edit config:' "$@")

# What to do when/if we choose a file to edit.
if [ "$choice" ]; then
    cfg=$(printf '%s\n' "${list["${choice}"]}")
    $FEDITOR "$cfg"
# What to do if we just escape without choosing anything.
else
    echo "No selection." && exit 0
fi

