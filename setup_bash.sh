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
    REQUIREMENTS='curl groups sudo'
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
        if groups | grep ${sug}; then
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
    DEPENDENCIES='autojump bash bash-completion tar exa'
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

installStarship(){
    if command_exists starship; then
        echo "Starship already installed"
        return
    fi

    if ! curl -sS https://starship.rs/install.sh | sh; then
        echo -e "${RED}Something went wrong during starship install!${RC}"
        exit 1
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
    cp -fv ${GITPATH}/.bashrc						${HOME}/.bashrc
    cp -fv ${GITPATH}/.inputrc						${HOME}/.inputrc
    cp -fv ${GITPATH}/.config/starship.toml				${HOME}/.config/starship.toml
    cp -rfv ${GITPATH}/.config/fastfetch/				${HOME}/.config/
    cp -rfv ${GITPATH}/.config/btop/					${HOME}/.config/
    cp -rfv ${GITPATH}/.config/alacritty/				${HOME}/.config/
    cp -rfv ${GITPATH}/.config/htop/					${HOME}/.config/
    cp -rfv ${GITPATH}/.config/neofetch/				${HOME}/.config/
}

checkEnv
installDepend
installStarship
if copyConfig; then
    echo -e "${GREEN}Done!\nRestart your shell to see the changes.${RC}"
else
    echo -e "${RED}OH! Something went wrong!${RC}"
fi
