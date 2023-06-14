# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# "bat" as manpager
#if type "bat" >/dev/null 2>&1; then
#    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
#    export MANROFFOPT="-c"
#fi
#alias man="man $1 | bat"

## User specific environment
# User scripts/bin to PATH
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi
# Flatpaks to PATH
if [ -d "/var/lib/flatpak/exports/bin/" ]; then
    PATH="/var/lib/flatpak/exports/bin/:$PATH"
fi
# AppImages to PATH
if [ -d "$HOME/Applications" ]; then
    PATH="$HOME/Applications:$PATH"
fi
export PATH

# ENVIRONMENT VARIABLES
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export HISTFILE="${XDG_STATE_HOME}"/bash_history
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export EDITOR=nvim
export TERMINAL=xst

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

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

# Disable history for consecutive identical commands and commands that start with space
export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTSIZE=3000
export HISTFILESIZE=3000

# Colored manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;91m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;93m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;92m'


## Utilities
# --- go back n directories ---
function b {
    str=""
    count=0
    while [ "$count" -lt "$1" ];
    do
        str=$str"../"
        let count=count+1
    done
    cd $str
}

# --- ARCHIVE EXTRACT ---

ex ()
{
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)   tar xjf $1   ;;
			*.tar.gz)    tar xzf $1   ;;
			*.bz2)       bunzip2 $1   ;;
			*.rar)       unrar x $1   ;;
			*.gz)        gunzip $1    ;;
			*.tar)       tar xf $1    ;;
			*.tbz2)      tar xjf $1   ;;
			*.tgz)       tar xzf $1   ;;
			*.zip)       unzip $1     ;;
			*.Z)         uncompress $1;;
			*.7z)        7za e x $1   ;;
			*.deb)       ar x $1      ;;
			*.tar.xz)    tar xf $1    ;;
			*.tar.zst)   unzstd $1    ;;
			*)           echo "'$1' cannot be extracted via ex()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# --- mkdir && cd ---
function mkcd ()
{
	mkdir -p "$1" && cd "$1";
}

## Aliases
alias \
		ls='ls --color=auto --group-directories-first' \
		la='ls -lhA --color=auto --group-directories-first' \
		ll='ls -lh --color=auto --group-directories-first' \
		grep='grep --color=auto' \
		ip='ip --color=auto' \
		cp='cp -iv' \
		mv='mv -iv' \
		rm='rm -Iv' \
		ln='ln -i' \
		df='df -h' \
		bc='bc -ql' \
		du='du -h' \
        mkd='mkdir -pv' \
		treestat='rpm-ostree status' \
		please='sudo !!' \
		zipit="tar -cvf \"$1\" | xz -T 0 -zevc > \"${1%/}.tar.xz\"" \
		itop='sudo intel_gpu_top' \
		imeas='sudo intel-undervolt measure' \
		vim='nvim' \
		weekly_main='sudo fstrim -va && sudo makewhatis && sudo xbps-remove -oOv' \
		errors='sudo dmesg --level=emerg,alert,crit,err,warn' \
        envy='sudo python /home/$USER/.local/bin/envycontrol.py'

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
# bat theme
export BAT_THEME="Dracula"

# Aliases for package managers
if type "xbps-install" >/dev/null 2>&1; then
	alias \
			xinstall='sudo xbps-install -S' \
			xremove='sudo xbps-remove -R' \
			xupdate='sudo xbps-install -Su' \
			xquery='xbps-query -Rs' \
			xorphan='sudo xbps-remove -ov' \
			xclean='sudo xbps-remove -Ov'
fi

# Aliases for flatpak
if type "flatpak" >/dev/null 2>&1; then
	alias \
			finstall='flatpak install' \
			fremove='flatpak uninstall --delete-data' \
			fupdate='flatpak update' \
			fquery='flatpak search' \
			forphan='flatpak uninstall --unused --delete-data'
fi

# Directory aliases
alias \
		home='~' \
		dl='$HOME/Downloads' \
		doc='$HOME/Documents'

# Prompt
[ -f /usr/local/bin/starship ] && eval "$(starship init bash)"

# Nice
type "neofetch" >/dev/null 2>&1 && neofetch

