#!/bin/sh
# Downloads and installs all my favorite fonts

url_nerdfonts="https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts"

echo "Downloading fonts.."
curl -fLO $url_nerdfonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf
curl -fLO $url_nerdfonts/Ubuntu/Regular/UbuntuNerdFont-Regular.ttf
curl -fLO $url_nerdfonts/ShareTechMono/ShureTechMonoNerdFont-Regular.ttf
curl -fLO $url_nerdfonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
curl -fLO $url_nerdfonts/Hack/Regular/HackNerdFont-Regular.ttf
curl -fLO https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized/raw/main/LigaSFMonoNerdFont-Regular.otf

echo "Moving fonts to ~/.local/share/fonts"
[ ! -d $HOME/.local/share/fonts ] && mkdir -p $HOME/.local/share/fonts
mv -f *.ttf $HOME/.local/share/fonts/
mv -f *.otf $HOME/.local/share/fonts/

echo "Updating font cache.."
fc-cache -f

echo "Done"
