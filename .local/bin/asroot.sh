#!/usr/bin/env bash

## Copyright (C) 2020-2023 Aditya Shakya <adi1090x@gmail.com>

## rofi sudo askpass helper
export SUDO_ASKPASS=/home/$USER/.local/bin/rofi-askpass

## execute the application
sudo -A $1
