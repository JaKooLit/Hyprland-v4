## Still in BETA stage

### A modified script of my Hyprland-v3 [`Link`](https://github.com/JaKooLit/Hyprland-v3)

![alt text](https://github.com/JaKooLit/Hyprland-v3.1/blob/main/screenshots/Sample-Tokyo-waybar.png "Default")

### ✨ What's new

- a. Can modify the packages easily on the install-script
- b. Dropped the Mc Mojave theme (apple like) in favor with Tokyo-night-theme
- c. using dunst instead of mako
- d. Added Tokyo SDDM Theme 

### ✨ to run
- clone this repo by using git. Change directory, make executable and run the script
- git clone https://github.com/JaKooLit/Hyprland-v3.5.git 
- cd Hyprland-v3.5 
- chmod +x install-hyprland-v3.5.sh 
- ./install-hyprland-v3.5.sh

### ✨ for ZSH and OH-MY-ZSH installation
- do this once installed and script completed; do the following to change the default shell zsh
```
chsh -s /bin/zsh
zsh
source .zshrc
```
- reboot or logout
- by default gnzh theme is installed. You can find more themes from this [`OH-MY-ZSH-THEMES`](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
- to change the theme, edit ~/.zshrc ZSH_THEME="desired theme"

### ✨ Roadmap:
- [ ] Use kitty in favor of foot
- [ ] Install zsh and oh-my-zsh without necessary steps above



### Special thanks to:
- @markob94 for testing of this script and fine tuning initial bugs