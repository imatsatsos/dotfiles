#!/bin/env bash
#
# SpotX for Spotify on NIX

echo "Script will patch with SpotX, the 'Nix' version of Spotify"; sleep 2;
bash <(curl -sSL https://raw.githubusercontent.com/SpotX-CLI/SpotX-Linux/main/install.sh) -P /home/john/.nix-profile/share/spotify
