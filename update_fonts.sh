#!/bin/sh
# Downloads and installs all my favorite fonts

url="https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts"

curl -fLO $url/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf
curl -fLO $url/Ubuntu/Regular/UbuntuNerdFont-Regular.ttf
curl -fLO $url/ShareTechMono/ShureTechMonoNerdFont-Regular.ttf
curl -fLO $url/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
curl -fLO $url/Hack/Regular/HackNerdFont-Regular.ttf
curl -fLO https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized/raw/main/LigaSFMonoNerdFont-Regular.otf

mkdir -p $HOME/.local/share/fonts
mv -f *.ttf $HOME/.local/share/fonts/
mv -f *.otf $HOME/.local/share/fonts/
fc-cache -f
echo "Done"
