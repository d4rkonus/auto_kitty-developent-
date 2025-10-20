#!/bin/bash

# Made by d4rkonus

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

ruta=$(pwd)   # ← corregido (sin espacio entre = y $(pwd))

# Check the user
check_root_user(){
    if [ "$EUID" -ne 0 ]; then
        echo -e "${redColour}[!] Please, run this script as Root User.${endColour}"
        exit 1
    fi
}

# Update the system
update_system(){
    echo -e "${blueColour}[+] Updating system...${endColour}"
    apt update -y && apt upgrade -y 2>&1
}
echo -e "${greenColour}[✓] System upgrades checked.${endColour}\n"

# Install kitty
install_kitty(){
    echo -e "${blueColour}[+] Installing Kitty and Zsh...${endColour}"
    apt install -y kitty zsh 2>&1
}
echo -e "${greenColour}[✓] Kitty installed.${endColour}\n"


# Move the fonts
move_fonts(){
   echo -e "${blueColour}[+] Moving fonts...${endColour}"
   cp -v "$ruta/fonts/"* /usr/share/fonts/ 2>&1
   fc-cache -fv >/dev/null 2>&1
}
echo -e "${greenColour}[✓] Fonts installed successfully.${endColour}\n"

# Create kitty files
create_kitty_files(){
    echo -e "${blueColour}[+] Creating kitty files...${endColour}"
    mkdir -p /home/$USER/.config/kitty 2>&1
    cp -vr "$ruta/config_kitty/"* /home/$USER/.config/kitty 2>&1
}
echo -e "${greenColour}[✓] Kitty really to road.${endColour}\n"



# Execution
#----------------------------------------------
check_root_user
update_system
install_kitty
move_fonts
create_kitty_files