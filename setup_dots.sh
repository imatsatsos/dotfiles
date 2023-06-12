#!/bin/bash

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'

command_exists () {
    command -v $1 >/dev/null 2>&1;
}

checkEnv() {
    ## Check for requirements.
    REQUIREMENTS='groups sudo'
    if ! command_exists ${REQUIREMENTS}; then
        echo -e "${RED}To run me, you need: ${REQUIREMENTS}${RC}"
        exit 1
    fi

    ## Check Package Handeler
    PACKAGEMANAGER='apt dnf pacman xbps-install'
    for pgm in ${PACKAGEMANAGER}; do
        if command_exists ${pgm}; then
            PACKAGER=${pgm}
            echo -e "Using ${pgm}"
        fi
    done

    if [ -z "${PACKAGER}" ]; then
        echo -e "${RED}Can't find a supported package manager${RC}"
        exit 1
    fi


    ## Check if the current directory is writable.
    #GITPATH="$(dirname "$(realpath "$0")")"
    GITPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    if [[ ! -w ${GITPATH} ]]; then
        echo -e "${RED}Can't write to ${GITPATH}${RC}"
        exit 1
    fi

    ## Check SuperUser Group
    SUPERUSERGROUP='wheel sudo'
    for sug in ${SUPERUSERGROUP}; do
        if groups | grep ${sug} >/dev/null; then
            SUGROUP=${sug}
            echo -e "Super user group ${SUGROUP}"
        fi
    done

    ## Check if member of the sudo group.
    if ! groups | grep ${SUGROUP} >/dev/null; then
        echo -e "${RED}You need to be a member of the sudo group to run me!${RC}"
        exit 1
    fi
    
}

installDepend() {
    ## Check for dependencies.
    DEPENDENCIES='curl git unzip autojump bash bash-completion tar exa bat fzf'
    echo -e "${YELLOW}Installing dependencies...${RC}"
    if [[ $PACKAGER == "pacman" ]]; then
        if ! command_exists paru; then
            echo "Installing paru.."
            sudo ${PACKAGER} --noconfirm -S --needed base-devel
            git clone https://aur.archlinux.org/paru.git && \
            sudo chown -R ${USER}:${USER} .paru && \
            cd paru && makepkg --noconfirm -si
        else
            echo "Command paru already installed"
        fi
    	paru --noconfirm -S --needed ${DEPENDENCIES}
    elif [[ $PACKAGER == "xbps-install" ]]; then
        sudo ${PACKAGER} -Sy ${DEPENDENCIES}
    else 
    	sudo ${PACKAGER} install -yq ${DEPENDENCIES}
    fi
}

installCursor() {
    echo -e "${YELLOW}Installing Breeze-Black cursor theme...${RC}"
    sleep 1
    mkdir -p ${HOME}/.local/share/icons/
    # install the icons in .local and symlink to ~/.icons, or xcursor wont work
    cp -rf ${GITPATH}/.local/share/icons/ ${HOME}/.local/share/
    ln -s ${HOME}/local/share/icons/ ${HOME}/.icons
}

installNerdFonts() {
    echo -e "${YELLOW}Installing some fonts...${RC}"
    sleep 1
    if fc-list | grep HackNerd >/dev/null; then 
		echo -e "${YELLOW}! HackNerd font already installed \n${RC}"
	else
		if command_exists curl; then
			curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/Hack.zip -o HackNerd.zip
			if [ ! -f HackNerd.zip ]; then
				echo -e "\${RED}! ERROR: Font download failed..${RC}"
			else
				unzip HackNerd.zip -d ./HackNerd
				[ ! -d ~/.local/share/fonts/ ] && mkdir -p ~/.local/share/fonts/
				mv ./HackNerd ~/.local/share/fonts/
				rm HackNerd.zip
				fc-cache -f
			fi
		else
			echo -e "${RED}ERROR: curl not found!${RC}"
			exit 1
		fi
	fi
    if fc-list | grep 'Liga SFMono Nerd' >/dev/null; then
        echo -e "${YELLOW}! Liga SFMono Nerd font already installed \n${RC}"
    else
        git clone https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git
        if [ ! -d SFMono-Nerd-Font-Ligaturized ]; then
            echo -e "${RED}! ERROR: git clone failed..${RC}"
        else
            mkdir -p ~/.local/share/fonts/SFMonoNerd/
            cp SFMono-Nerd-Font-Ligaturized/*.otf ~/.local/share/fonts/SFMonoNerd/
        fi
    fi
}

installStarship(){
    if command_exists starship; then
        echo "Starship already installed"
        return
    fi

    if ! curl -sS https://starship.rs/install.sh | sh; then
        echo -e "${RED}Something went wrong during starship install!${RC}"
        #exit 1
    fi
}

copyConfig() {
    ## Check if a bashrc file is already there.
    OLD_BASHRC="${HOME}/.bashrc"
    if [[ -e ${OLD_BASHRC} ]]; then
        echo -e "${YELLOW}Moving old bash config file to ${HOME}/.bashrc.bak${RC}"
        if ! mv ${OLD_BASHRC} ${HOME}/.bashrc.bak; then
            echo -e "${RED}Can't move the old bash config file!${RC}"
            exit 1
        fi
    fi

    echo -e "${YELLOW}Copying new config files...${RC}"
    # Copying files to destination and overwriting
    cp -f ${GITPATH}/.bashrc				    ${HOME}/.bashrc
    cp -f ${GITPATH}/.gtkrc-2.0				    ${HOME}/.gtkrc-2.0
    cp -f ${HOME}/.bash_history			        ${HOME}/.local/state/bash_history
    cp -f ${GITPATH}/.inputrc				    ${HOME}/.inputrc
    cp -f ${GITPATH}/.Xresources                ${HOME}/.Xresources
    [ ! -d ${HOME}/.local/ ] && mkdir -p        ${HOME}/.local/
    cp -rf ${GITPATH}/bin/				        ${HOME}/.local/
    [ ! -d ${HOME}/.config/ ] && mkdir -p       ${HOME}/.config/
    cp -f ${GITPATH}/.config/starship.toml		${HOME}/.config/
    cp -f ${GITPATH}/.config/background	        ${HOME}/.config/
    cp -f ${GITPATH}/.config/lockscreen.png	    ${HOME}/.config/
    cp -rf ${GITPATH}/.config/dunst/	        ${HOME}/.config/dunst/
    cp -rf ${GITPATH}/.config/alacritty/		${HOME}/.config/alacritty/
    cp -rf ${GITPATH}/.config/btop/			    ${HOME}/.config/btop/
    cp -rf ${GITPATH}/.config/fastfetch/		${HOME}/.config/fastfetch/
    cp -rf ${GITPATH}/.config/git/              ${HOME}/.config/git/
    cp -rf ${GITPATH}/.config/htop/			    ${HOME}/.config/htop/
    cp -rf ${GITPATH}/.config/neofetch/		    ${HOME}/.config/neofetch/
    cp -rf ${GITPATH}/.config/MangoHud/		    ${HOME}/.config/MangoHud/
    cp -rf ${GITPATH}/.config/i3/               ${HOME}/.config/
    cp -rf ${GITPATH}/.config/gtk-3.0/          ${HOME}/.config/
}

checkEnv
installDepend
installNerdFonts
installCursor
installStarship
if copyConfig; then
    echo -e "${GREEN}Done!\nRestart your shell to see the changes.${RC}"
else
    echo -e "${RED}OH! Something went wrong!${RC}"
fi
