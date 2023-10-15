#!/bin/bash

# Determine the directory where the dotfiles.sh script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
cd "$SCRIPT_DIR/.." || exit 1

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S)_dotfiles.log"

# preparing hyprland.conf keyboard layout
# Function to detect keyboard layout in an X server environment
detect_x_layout() {
  layout=$(setxkbmap -query | grep layout | awk '{print $2}')
  if [ -n "$layout" ]; then
    echo "$layout"
  else
    echo "unknown"
  fi
}

# Function to detect keyboard layout in a tty environment
detect_tty_layout() {
  layout=$(localectl status --no-pager | awk '/X11 Layout/ {print $3}')
  if [ -n "$layout" ]; then
    echo "$layout"
  else
    echo "unknown"
  fi
}

# Detect the current keyboard layout based on the environment
if [ -n "$DISPLAY" ]; then
  # System is in an X server environment
  layout=$(detect_x_layout)
else
  # System is in a tty environment
  layout=$(detect_tty_layout)
fi

echo "Keyboard layout: $layout"

printf "${NOTE} Detecting keyboard layout to prepare necessary changes in hyprland.conf before copying\n"
printf "\n"

# Prompt the user to confirm whether the detected layout is correct
read -p "Detected keyboard layout or keymap: $layout. Is this correct? [y/n] " confirm

if [ "$confirm" = "y" ]; then
  # If the detected layout is correct, update the 'kb_layout=' line in the file
  awk -v layout="$layout" '/kb_layout/ {$0 = "  kb_layout=" layout} 1' config/hypr/configs/Settings.conf > temp.conf
  mv temp.conf config/hypr/configs/Settings.conf
else
  # If the detected layout is not correct, prompt the user to enter the correct layout
  printf "${WARN} Ensure to type in the proper keyboard layout, e.g., gb, de, pl, etc.\n"
  read -p "Please enter the correct keyboard layout: " new_layout
  # Update the 'kb_layout=' line with the correct layout in the file
  awk -v new_layout="$new_layout" '/kb_layout/ {$0 = "  kb_layout=" new_layout} 1' config/hypr/configs/Settings.conf > temp.conf
  mv temp.conf config/hypr/configs/Settings.conf
fi
printf "\n"

### Copy Config Files ###
set -e # Exit immediately if a command exits with a non-zero status.

printf "${NOTE} copying dotfiles\n"
  for DIR in btop cava foot hypr neofetch swappy swaylock waybar wofi; do 
    DIRPATH=~/.config/$DIR
    if [ -d "$DIRPATH" ]; then 
      echo -e "${NOTE} - Config for $DIR found, attempting to back up."
      mv $DIRPATH $DIRPATH-back-up 2>&1 | tee -a "$LOG"
      echo -e "${NOTE} - Backed up $DIR to $DIRPATH-back-up."
    fi
  done

  for DIRw in wallpapers; do 
    DIRPATH=~/Pictures/$DIRw
    if [ -d "$DIRPATH" ]; then 
      echo -e "${NOTE} - wallpapers in $DIRw found, attempting to back up."
      mv $DIRPATH $DIRPATH-back-up 2>&1 | tee -a "$LOG"
      echo -e "${NOTE} - Backed up $DIRw to $DIRPATH-back-up."
    fi
  done

  # Copying config files
  printf " Copying config files...\n"
  mkdir -p ~/.config
  cp -r config/hypr ~/.config/ && { echo "Copy completed!"; } || { echo "Error: Failed to copy hypr config files."; exit 1; } 2>&1 | tee -a "$LOG"
  cp -r config/foot ~/.config/ || { echo "Error: Failed to copy foot config files."; exit 1; } 2>&1 | tee -a "$LOG"
  cp -r config/btop ~/.config/ || { echo "Error: Failed to copy btop config files."; exit 1; } 2>&1 | tee -a "$LOG"
  cp -r config/cava ~/.config/ || { echo "Error: Failed to copy cava config files."; exit 1; } 2>&1 | tee -a "$LOG"
  cp -r config/neofetch ~/.config/ || { echo "Error: Failed to copy neofetch config files."; exit 1; } 2>&1 | tee -a "$LOG"
  cp -r config/swappy ~/.config/ || { echo "Error: Failed to copy swappy config files."; exit 1; } 2>&1 | tee -a "$LOG"
  mkdir -p ~/Pictures/wallpapers
  cp -r wallpapers ~/Pictures/ && { echo "Copy completed!"; } || { echo "Error: Failed to copy wallpapers."; exit 1; } 2>&1 | tee -a "$LOG"

  # symlinks for waybar
  ln -sf "$HOME/.config/hypr/waybar/configs/config-default" "$HOME/.config/hypr/waybar/config" && \
  ln -sf "$HOME/.config/hypr/waybar/style/dark-styles/style-dark-tokyo.css" "$HOME/.config/hypr/waybar/style.css" && \

  # symlinks for dunst
  ln -sf "$HOME/.config/hypr/dunst/styles/dunstrc-dark" "$HOME/.config/hypr/dunst/dunstrc" && \

  # symlink for wofi
  ln -sf "$HOME/.config/hypr/wofi/styles/style-dark.css" "$HOME/.config/hypr/wofi/style.css" && \
  
  # Set some files as executable
  chmod +x ~/.config/hypr/scripts/* 2>&1 | tee -a "$LOG"

# Clear screen
clear