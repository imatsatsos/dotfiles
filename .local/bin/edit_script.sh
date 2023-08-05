#!/usr/bin/env sh
#
# Script displays a fzf menu of scripts to edit
# DEPENDS: fzf, vim

fmenu="fzf --border=rounded --margin=5% --color=dark --height 100% --reverse --header=$(basename "$0") --info=hidden --header-first --prompt"
#FTERM="xst -g=89x32"
feditor="vim"

scripts="$HOME/.local/bin/"

 # Piping the above array (cleaned) into fzf.
 # We use "printf '%s\n'" to format the array one item to a line.
 choice=$(find $scripts | ${fmenu} 'Edit script:' "$@")

# What to do when/if we choose a file to edit.
if [ "$choice" ]; then
    $feditor "$choice"
# What to do if we just escape without choosing anything.
else
    exit 0
fi

