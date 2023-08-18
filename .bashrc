#!/bin/env bash
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
unset rc

#  ___ _  _  ___  ___ _____ ___ 
# / __| || |/ _ \| _ \_   _/ __|
# \__ \ __ | (_) |  _/ | | \__ \
# |___/_||_|\___/|_|   |_| |___/
# Turn on parallel history (= do not override history)
shopt -s histappend
# Turn on check window size after each command
shopt -s checkwinsize
# Enable automatic cd to paths
shopt -s autocd
# Autocorrects cd misspellings
shopt -s cdspell
# Expand aliases
shopt -s expand_aliases
# Expand dot filenames
shopt -s dotglob

#  _  _ ___ ___ _____ ___  _____   __
# | || |_ _/ __|_   _/ _ \| _ \ \ / /
# | __ || |\__ \ | || (_) |   /\ V / 
# |_||_|___|___/ |_| \___/|_|_\ |_|  
# Disable history for consecutive identical commands and commands that start with space
export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTSIZE=10000
export HISTFILESIZE=10000

#  __  __   _   _  _ 
# |  \/  | /_\ | \| |
# | |\/| |/ _ \| .` |
# |_|  |_/_/ \_\_|\_|
# Colored manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;91m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;93m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;92m'
export LESS_TERMCAP_ue=$'\E[0m'
export BAT_THEME="base16"
## "bat" as manpager
# if type "bat" >/dev/null 2>&1; then
#    export MANPAGER="/home/$USER/.local/bin/bat-wrapper"
#    man 2 select
#    export MANROFFOPT="-c"
# fi

#  ___ _   _ _  _  ___ ___ 
# | __| | | | \| |/ __/ __|
# | _|| |_| | .` | (__\__ \
# |_|  \___/|_|\_|\___|___/
# --- Go-back-n directories ---
function b {
	str=""
	count=0
	while [ "$count" -lt "$1" ];
	do
		str=$str"../"
		count=$((count+1))
	done
	cd $str || return
}

# --- Archive Extract ---

ex ()
{
	if [ -f "$1" ] ; then
		case $1 in
			*.tar.bz2) tar xjf    "$1" ;;
			*.tar.gz)  tar xzf    "$1" ;;
			*.bz2)     bunzip2    "$1" ;;
			*.rar)     unrar x    "$1" ;;
			*.gz)      gunzip     "$1" ;;
			*.tar)     tar xf     "$1" ;;
			*.tbz2)    tar xjf    "$1" ;;
			*.tgz)     tar xzf    "$1" ;;
			*.zip)     unzip      "$1" ;;
			*.Z)       uncompress "$1" ;;
			*.7z)      7z x       "$1" ;;
			*.deb)     ar x       "$1" ;;
			*.tar.xz)  tar xf     "$1" ;;
			*.tar.zst) unzstd     "$1" ;;
			*)         echo "'$1' cannot be extracted via ex()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# --- mkdir && cd ---
mkcd () {
	mkdir -p "$1" && cd "$1" || return
}

# --- list monospace fonts only ---
listmono () {
	fc-list :mono | awk -F: '{print $2}' | sort -u
}

#    _   _    ___   _   ___ 
#   /_\ | |  |_ _| /_\ / __|
#  / _ \| |__ | | / _ \\__ \
# /_/ \_\____|___/_/ \_\___/
alias \
	ls='ls --color=auto --group-directories-first' \
	la='ls -lhA --color=auto --group-directories-first' \
	ll='ls -lh --color=auto --group-directories-first' \
	grep='grep --color=auto' \
	ip='ip --color=auto' \
	diff='diff --color=auto' \
	cp='cp -iv' \
	mv='mv -iv' \
	rm='rm -Iv' \
	ln='ln -i' \
	df='df -h' \
	bc='bc -ql' \
	du='du -h' \
	mkd='mkdir -pv' \
	treestat='rpm-ostree status' \
	fuck='sudo !!' \
	zipit="tar -cvf \"$1\" | xz -T 0 -zevc > \"${1%/}.tar.xz\"" \
	zap="tar -cvf archive.tar.xz --use-compress-program='xz -T0' \"$1\"" \
	itop='sudo intel_gpu_top' \
	imeas='sudo intel-undervolt measure' \
	vim='nvim' \
	es='edit_script.sh' \
	ec='edit_cfg.sh' \
	weekly_main='sudo fstrim -va && sudo makewhatis && sudo xbps-remove -oOv && sudo vkpurge rm all' \
	errors='sudo dmesg --level=emerg,alert,crit,err,warn' \
	envy='sudo python /home/$USER/.local/bin/envycontrol.py' \
	fh='inpt=$(history | cut -c 5 | fzf -0 --tac) && echo "$inpt" | xclip -r -selection c'

# exa for ls
if type "exa" >/dev/null 2>&1; then
	alias \
		ls='exa --icons --group-directories-first' \
		la='exa -al --icons --group-directories-first' \
		ll='exa -l --icons --group-directories-first' \
		lg='exa -al --git --icons'
fi

# bat for cat
if type "bat" >/dev/null 2>&1; then
	alias cat="bat"
fi

# Aliases for package managers
if type "xbps-install" >/dev/null 2>&1; then
	alias \
		xinstall='sudo xbps-install -S' \
		xremove='sudo xbps-remove -R' \
		xupdate='sudo xbps-install -Su' \
		xquery='xbps-query' \
		xsearch='xbps-query -Rs' \
		xowned='xbps-query -o' \
		xorphan='sudo xbps-remove -ov' \
		xclean='sudo xbps-remove -Ov' \
		xinf="xbps-query -Rs \"\" | cut --delimiter \" \" --fields 1-2 | fzf --multi --exact --cycle --reverse --preview 'xbps-query -R {2}' | cut --delimiter \" \" --fields 2 | xargs -ro sudo xbps-install" \
		xrmf="xbps-query -m | fzf --prompt=\"Select package(s) to remove: \" --multi --margin 10% --padding 10% --border | xargs -ro sudo xbps-remove -Ro" \
		xfzf="xbps-query -m | fzf --preview 'xbps-query -S {}' --height=97% --layout=reverse --bind 'enter:execute(xbps-query -S {} | less)'"

fi

# Aliases for flatpak
if type "flatpak" >/dev/null 2>&1; then
	alias \
		finstall='flatpak install' \
		fremove='flatpak uninstall --delete-data' \
		fupdate='flatpak update' \
		fsearch='flatpak search' \
		forphan='flatpak uninstall --unused --delete-data' \
		flist='flatpak list --app --columns=name,application,runtime,version'
fi

# Directory aliases
alias \
	dl='cd $HOME/Downloads && ll' \
	doc='cd $HOME/Documents && ll' \
	gr='cd $HOME/Gitrepos/ && ll'

#  ___  ___ _ 
# | _ \/ __/ |
# |  _/\__ \ |
# |_|  |___/_|
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# get current branch in git repo
function parse_git_branch() {
	BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=$(parse_git_dirty)
		echo " [${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=$(git status 2>&1 | tee)
	dirty=$(echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?")
	untracked=$(echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?")
	ahead=$(echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?")
	newfile=$(echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?")
	renamed=$(echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?")
	deleted=$(echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?")
	bits=''
	if [ "${renamed}" == "0" ]; then bits=">${bits}"; fi
	if [ "${ahead}" == "0" ]; then bits="*${bits}"; fi
	if [ "${newfile}" == "0" ]; then bits="+${bits}"; fi
	if [ "${untracked}" == "0" ]; then bits="?${bits}"; fi
	if [ "${deleted}" == "0" ]; then bits="x${bits}"; fi
	if [ "${dirty}" == "0" ]; then bits="!${bits}"; fi
	if [ ! "${bits}" == "" ]; then echo " ${bits}"; else echo ""; fi
}

#old PS1='\n\[\e[34m\]\u\[\e[0;2;3m\]@\h \[\e[0m\]\w ($(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2)) [$?] \$ '
PS1='\n\[\e[34m\]\u\[\e[0;2;3m\]@\h \[\e[0m\]\w\[\e[93m\]$(parse_git_branch)\[\e[0m\] \$ '

#  ___ _    ___ _  _  ___ 
# | _ ) |  |_ _| \| |/ __|
# | _ \ |__ | || .` | (_ |
# |___/____|___|_|\_|\___|

type "neofetch" >/dev/null 2>&1 && neofetch
#[ -f /usr/local/bin/starship ] && eval "$(starship init bash)"

