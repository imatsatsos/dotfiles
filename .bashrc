# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    if  [ -d "$HOME/bin" ];
        then PATH="$HOME/bin:$PATH"
    fi
    if [ -d "$HOME/.local/bin" ];
        then PATH="$HOME/.local/bin:$PATH"
    fi
fi
export PATH

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

# Disable history for consecutive identical commands and commands that start with space
export HISTCONTROL=ignoredups:erasedups:ignorespace

# Aliases
alias \
		ls='ls --color=auto --group-directories-first' \
		la='ls -alh --color=auto --group-directories-first' \
		ll='ls -lh --color=auto --group-directories-first' \
		grep='grep --color=auto' \
		ip='ip --color=auto' \
		cp='cp -iv' \
		mv='mv -iv' \
		rm='rm -Iv' \
		ln='ln -i' \
		df='df -h' \
		bc='bc -ql' \
		mkd='mkdir -pv' \
		mcd='mkd $1; cd $1' \
		treestat='rpm-ostree status' \
		please='sudo !!' \
		zipit='tar cf - "$1" | xz -T 0 -zevc > "${1%/}.tar.xz"'
		itop='sudo intel_gpu_top'
		vim='nvim'
		
if type "exa" >/dev/null 2>&1; then
	alias \
			ls='exa --icons --group-directories-first' \
			la='exa -al --icons --group-directories-first' \
			ll='exa -l --icons --group-directories-first'
fi

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

# Aliases for package managers
if type "xbps-install" >/dev/null 2>&1; then
	alias \
			install='sudo xbps-install -S' \
			remove='sudo xbps-remove -R' \
			update='sudo xbps-install -Su' \
			query='xbps-query -Rs' \
			orphan='sudo xbps-remove -ov' \
			clean='sudo xbps-remove -Ov'
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
type "ufetch" >/dev/null 2>&1 && ufetch
