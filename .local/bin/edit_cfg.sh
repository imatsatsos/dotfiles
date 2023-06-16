#!/usr/bin/bash
#
# Scripts displays a fzf menu of configs to edit

declare -A confedit_list
confedit_list[alacritty]="$HOME/.config/alacritty/alacritty.yml"
confedit_list[alacritty_color]="$HOME/.config/alacritty/alacritty_color.yml"
confedit_list[alacritty_font]="$HOME/.config/alacritty/alacritty_font.yml"
confedit_list[bash]="$HOME/.bashrc"
confedit_list[fastfetch]="$HOME/.config/fastfetch/config.conf"
confedit_list[inputrc]="$HOME/.inputrc"
confedit_list[mpv]="$HOME/.config/mpv/mpv.conf"
confedit_list[neofetch]="$HOME/.config/neofetch/config.conf"
confedit_list[starship]="$HOME/.config/starship.toml"
confedit_list[neovim]="$HOME/.config/nvim/init.vim"
#confedit_list[ssh]="$HOME/.ssh/config"
confedit_list[xresources]="$HOME/.Xresources"
confedit_list[i3-config]="$HOME/.config/i3/config"
confedit_list[i3-blocks]="$HOME/.config/i3/i3blocks.conf"
confedit_list[i3-window-titles]="$HOME/.config/window_titles.yml"
confedit_list[mangohud]="$HOME/.config/MangoHud/MangoHud.conf"
confedit_list[dunst]="$HOME/.config/dunst/dunstrc"

FMENU="fzf --border=rounded --margin=5% --color=dark --height 100% --reverse --header=$(basename "$0") --info=hidden --header-first --prompt"
#FTERM="xst -g=89x32"
FEDITOR="vim"

 # Piping the above array (cleaned) into fzf.
 # We use "printf '%s\n'" to format the array one item to a line.
choice=$(printf '%s\n' "${!confedit_list[@]}" | sort | ${FMENU} 'Edit config:' "$@")

# What to do when/if we choose a file to edit.
if [ "$choice" ]; then
    cfg=$(printf '%s\n' "${confedit_list["${choice}"]}")
    $FEDITOR "$cfg"
# What to do if we just escape without choosing anything.
else
    echo "Program terminated." && exit 0
fi

