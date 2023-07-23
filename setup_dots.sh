#!/bin/bash

RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'
RC='\e[0m'

command_exists () {
    command -v $1 >/dev/null 2>&1;
}

font_exists () {
    fc-list | grep "$1" >/dev/null 2>&1 
}

checkEnv() {
    ## Check for requirements.
    REQUIREMENTS='groups sudo'
    if ! command_exists ${REQUIREMENTS}; then
        echo -e "${RED}To run me, you need: ${REQUIREMENTS}${RC}"
        exit 1
    fi

    ## Check Package Handler
    PACKAGEMANAGER='apt dnf pacman xbps-install'
    for pgm in ${PACKAGEMANAGER}; do
        if command_exists ${pgm}; then
            PACKAGER=${pgm}
            echo -e "Using ${pgm}"
        fi
    done

    if [ -z "$PACKAGER" ]; then
        echo -e "${RED}Can't find a supported package manager${RC}"
        exit 1
    fi

    ## Check if the current directory is writable.
    #GITPATH="$(dirname "$(realpath "$0")")"
    GITPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    if [[ ! -w $GITPATH ]]; then
        echo -e "${RED}Can't write to $GITPATH ${RC}"
        exit 1
    fi

    ## Check SuperUser Group
    SUPERUSERGROUP='wheel sudo'
    for sug in ${SUPERUSERGROUP}; do
        if groups | grep ${sug} >/dev/null; then
            SUGROUP=${sug}
            echo -e "Super-user group: ${SUGROUP}"
        fi
    done

    ## Check if member of the sudo group.
    if ! groups | grep ${SUGROUP} >/dev/null; then
        echo -e "${RED}You need to be a member of the sudo group to run me!${RC}"
        exit 1
    fi

    ## Notify user of what it is to come.
    echo -e "${RED}This script doesn't backup files. This script will install \
config files in your ~ and ~/.config folder. Backup configs you don't want \
to lose. Do you wish to continue?  [y/N]${RC}"
    read -r ans
    [ "$ans" = "y" ] || [ "$ans" = "Y" ] || exit
}

installDepend() {
    ## Check for dependencies.
    DEPENDENCIES='curl git unzip bash bash-completion tar exa bat fzf'
    echo -e "${YELLOW}Installing dependencies..${RC}"
    if [[ $PACKAGER == "pacman" ]]; then
        if ! command_exists paru; then
            echo -e "${YELLOW}Installing paru..\n${RC}"
            sudo $PACKAGER --noconfirm -S --needed base-devel
            git clone https://aur.archlinux.org/paru.git && \
            sudo chown -R ${USER}:${USER} paru && \
            cd paru && makepkg --noconfirm -si
        else
            echo "${YELLOW}Command paru already installed\n${RC}"
        fi
    	paru --noconfirm -S --needed ${DEPENDENCIES}
    elif [[ $PACKAGER == "xbps-install" ]]; then
        sudo $PACKAGER -Sy ${DEPENDENCIES}
    else 
    	sudo $PACKAGER install -yq ${DEPENDENCIES}
    fi
    echo -e "${GREEN}DONE\n${RC}"
}

installCursor() {
    echo -e "${YELLOW}Installing Breeze-Black cursor theme..\n${RC}"
    sleep 1
    # create icons dir
    [ ! -d $HOME/.local/share/icons ] && mkdir -p $HOME/.local/share/icons/
    # download cursors
    curl -fLO https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.0/BreezeX-Black.tar.gz || return
    # extract it
    tar -xzf $GITPATH/BreezeX-Black.tar.gz
    # clean up
    rm -f $GITPATH/BreezeX-Black.tar.gz
    # move extracted folder ~/.local/share/icons
    mv -f $GITPATH/BreezeX-Black "$HOME/.local/share/icons/BreezeX-Black/"
    #cp -rf $GITPATH/.local/share/icons/ $HOME/.local/share/
    # backup old ~/.icons
    [ -d $HOME/.icons ] && mv $HOME/.icons $HOME/.iconsbak
    # symlink .local/share/icons to ~/.icons, or X11 cursor won't work
    ln -s $HOME/.local/share/icons/ $HOME/.icons
    echo -e "${GREEN}DONE\n${RC}"
}

copyFonts() {
    echo -e "${YELLOW}Installing fonts..${RC}"
    [ ! -d $HOME/.local/share/fonts ] && mkdir -p $HOME/.local/share/fonts
    cp -rf $GITPATH/.local/share/fonts/* $HOME/.local/share/fonts/
    fc-cache -f
    echo -e "${GREEN}DONE\n${RC}"
}

installStarship(){
    if command_exists starship; then
        echo -e "${YELLOW}Starship already installed!\n${RC}"
        return
    fi

    echo -e "${YELLOW}Installing Starship.."
    if ! curl -sS https://starship.rs/install.sh | sh; then
        echo -e "${RED}! ERROR: Something went wrong during starship install${RC}"
        sleep 1
    fi
    echo -e "${GREEN}DONE\n${RC}"
}

copyConfig() {
    ## Check if a bashrc file is already there.
    OLD_BASHRC="$HOME/.bashrc"
    if [[ -e $OLD_BASHRC ]]; then
        echo -e "${YELLOW}Moving old bash config file to $HOME/.bashrc.bak${RC}"
        if ! mv -f $OLD_BASHRC $HOME/.bashrc.bak; then
            echo -e "${RED}! ERROR: Can't move the old bash config file${RC}"
            exit 1
        fi
    fi

    echo -e "${YELLOW}Copying new config files..${RC}"
    # Copying files to destination and overwriting
    cp -rf $GITPATH/. $HOME
    # Moving existing files to clean up home directory
    mkdir -p $HOME/.local/state
    if [ -f $HOME/.bash_history ]; then
        mv -f $HOME/.bash_history $HOME/.local/state/bash_history
    else
        touch $HOME/.local/state/bash_history
    fi
    # clean up
    rm -rf $HOME/setup_dots.sh $HOME/LICENSE $HOME/.git $HOME/download_fonts.sh $HOME/i3pkgs.sh
    echo -e "${GREEN}DONE\n${RC}"
}

checkEnv
installDepend
installCursor
installStarship
copyFonts
if copyConfig; then
    echo -e "${GREEN}Restart your shell to see the changes.${RC}"
else
    echo -e "${RED}! ERROR: Something went wrong during .dots copy${RC}"
fi
