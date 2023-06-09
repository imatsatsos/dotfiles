#!/usr/bin/bash
#
# Script displays a fzf menu of scripts to edit

FMENU="fzf --border=rounded --margin=5% --color=dark --height 100% --reverse --header=$(basename "$0") --info=hidden --header-first --prompt"
#FTERM="xst -g=89x32"
FEDITOR="vim"

SCRIPTS_FOLDER1="$HOME/.local/bin/*"
SCRIPTS_FOLDER2="$HOME/.config/i3/scripts/*"

SCRIPTS="$SCRIPTS_FOLDER1 $SCRIPTS_FOLDER2"

 # Piping the above array (cleaned) into fzf.
 # We use "printf '%s\n'" to format the array one item to a line.
 choice=$(ls -d $SCRIPTS | ${FMENU} 'Edit script:' "$@")

# What to do when/if we choose a file to edit.
if [ "$choice" ]; then
    $FEDITOR "$choice"
# What to do if we just escape without choosing anything.
else
    echo "Program terminated." && exit 0
fi

