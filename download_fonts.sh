#!/bin/bash

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'


font_exists () {
    fc-list | grep "$1" >/dev/null 2>&1 
}

installFonts() {
    echo -e "${GREEN}Do you want to install some fonts?    [Y/N]${RC}"
    read -r dm
    if [[ "$dm" == [Y/y] ]]; then
        FONTFOLDER="$HOME/.local/share/fonts"
        echo -e "${YELLOW}Installing some fonts..${RC}"
        sleep 1
        [ ! -d "$FONTFOLDER" ] && mkdir -p "$FONTFOLDER"
        
        # Font: Hack Nerd
        if font_exists HackNerd; then 
            echo -e "${YELLOW}! Hack Nerd already installed \n${RC}"
        else
            curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/Hack.zip -o HackNerd.zip
            if [ ! -f HackNerd.zip ]; then
                echo -e "${RED}! ERROR: curl font download failed..${RC}"
            else
                unzip HackNerd.zip -d ./HackNerd
                mv ./HackNerd/ "$FONTFOLDER"
                rm HackNerd.zip
                echo -e "${YELLOW}Hack Nerd font installed!${RC}"
            fi
        fi
        
        # Font: San Francisco Mono Nerd
        if font_exists 'Liga SFMono Nerd'; then 
            echo -e "${YELLOW}! San Francisco Mono Nerd already installed \n${RC}"
        else
            git clone https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git
            if [ ! -d SFMono-Nerd-Font-Ligaturized ]; then
                echo -e "${RED}! ERROR: git clone failed${RC}"
            else
                mkdir -p "$FONTFOLDER/SFMonoNerd/"
                cp -rf "./SFMono-Nerd-Font-Ligaturized/*.otf" "$FONTFOLDER/SFMonoNerd/"
                rm -rf "./SFMono-Nerd-Font-Ligaturized/"
                echo -e "${YELLOW}San Fransisco Mono Nerd font installed!${RC}"
            fi
        fi
        # update font cache
        fc-cache -f
    fi
}
