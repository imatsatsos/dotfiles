#!/usr/bin/bash
#
# Scripts displays a fzf menu of configs to edit

declare -A list
list[alacritty]="$HOME/.config/alacritty/alacritty.yml"
list[alacritty_color]="$HOME/.config/alacritty/alacritty_color.yml"
list[alacritty_font]="$HOME/.config/alacritty/alacritty_font.yml"
list[bash]="$HOME/.bashrc"
list[fastfetch]="$HOME/.config/fastfetch/config.conf"
list[git]="$HOME/.config/git/config"
list[inputrc]="$HOME/.inputrc"
list[mpv]="$HOME/.config/mpv/mpv.conf"
list[neofetch]="$HOME/.config/neofetch/config.conf"
list[starship]="$HOME/.config/starship.toml"
list[neovim]="$HOME/.config/nvim/init.lua"
#list[ssh]="$HOME/.ssh/config"
list[xresources]="$HOME/.Xresources"
list[i3-config]="$HOME/.config/i3/config"
list[i3-blocks]="$HOME/.config/i3/i3blocks.conf"
list[i3-window-titles]="$HOME/.config/window_titles.yml"
list[mangohud]="$HOME/.config/MangoHud/MangoHud.conf"
list[dunst]="$HOME/.config/dunst/dunstrc"
list[picom]="$HOME/.config/picom/picom.conf"
list[sway]="$HOME/.config/sway/config"

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
    echo "Program terminated." && exit 0
fi

