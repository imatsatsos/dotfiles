# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

#### Start of my .bashrc

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

# Turn on parallel history
shopt -s histappend
# Turn on check window size after each command
shopt -s checkwinsize
# Enable automatic cd to paths
shopt -s autocd
# Disable history for consecutive identical commands and commands that start with space
export HISTCONTROL=erasedups:ignorespace

# Aliases
alias \
			ls='ls -h --color=auto --group-directories-first' \
			la='ls -al --color=auto --group-directories-first' \
			grep='grep --color=auto' \
			ip='ip --color=auto' \
			cp='cp -iv' \
			mv='mv -iv' \
			rm='rm -vI' \
			bc='bc -ql' \
			mkd='mkdir -pV' \
			mcd='mkd $1; cd $1' \
			treestat='rpm-ostree status' \
			please='sudo !!' \
			zipit='tar cf - "$1" | xz -T 0 -zevc > "${1%/}.tar.xz"'
	# exa for la, ll
if type "exa" >/dev/null 2>&1; then
	alias \
				la='exa -al --icons --group-directories-first' \
				ll='exa -l --icons --group-directories-first'
fi

# Directory aliases
alias \
			home='~' \
			dl='~/Downloads' \
			doc='~/Documents'

# Prompt
[ -f /usr/local/bin/starship ] && eval "$(starship init bash)"

# Nice
type "fastfetch" >/dev/null 2>&1 && fastfetch
