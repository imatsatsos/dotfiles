#!/bin/sh
# Downloads and installs all my favorite fonts

url_nerdfonts="https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts"

dl="curl -fLO"

echo "Downloading fonts.."
$dl $url_nerdfonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf
$dl $url_nerdfonts/Ubuntu/Regular/UbuntuNerdFont-Regular.ttf
$dl https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/UbuntuMonoNerdFont-Regular.ttf
$dl $url_nerdfonts/ShareTechMono/ShureTechMonoNerdFont-Regular.ttf
$dl $url_nerdfonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
$dl $url_nerdfonts/Hack/Regular/HackNerdFont-Regular.ttf
$dl https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized/raw/main/LigaSFMonoNerdFont-Regular.otf

echo "Moving fonts to ~/.local/share/fonts"
[ ! -d $HOME/.local/share/fonts ] && mkdir -p $HOME/.local/share/fonts
mv -f *.ttf $HOME/.local/share/fonts/
mv -f *.otf $HOME/.local/share/fonts/

echo "Updating font cache.."
fc-cache -f

echo "Done"
