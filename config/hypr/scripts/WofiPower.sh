#!/usr/bin/env bash

# WOFI STYLES
CONFIG="$HOME/.config/hypr/wofi/WofiBig/config"
STYLE="$HOME/.config/hypr/wofi/style.css"
COLORS="$HOME/.config/hypr/wofi/colors"

# Wofi window config (in %)
WOFI_WIDTH=28
WOFI_HEIGHT=8

wofi_command="wofi --show dmenu \
			--prompt choose... \
			--conf $CONFIG --style $STYLE --color $COLORS \
			--width=$WOFI_WIDTH% --height=$WOFI_HEIGHT% \
			--cache-file=/dev/null \
			--hide-scroll --no-actions \
			--matching=fuzzy"
			
entries=$(echo -e " Poweroff\n Reboot\n Suspend\n Lock\n Logout" | $wofi_command -i --dmenu | awk '{print tolower($2)}')

case $entries in 
    poweroff|reboot|suspend)
        systemctl $entries
        ;;
    lock)
        $HOME/.config/hypr/scripts/LockScreen.sh
        ;;
    logout)
        hyprctl dispatch exit 0
        ;;
esac
