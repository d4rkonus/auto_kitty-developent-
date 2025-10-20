#!/bin/bash

# Made by d4rkonus

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


# Check the user

check_root_user(){
    if [ "$UID" -ne 0 ]; then
        echo "Please, run this script as Root User."
        exit 1
    fi
}


# Update to the system

update_system(){
    apt update -y && apt upgrade -y 2>&1
}


# Install kitty

install_kitty(){
    apt install -y kitty zsh 2>&1
}

# Move the fonts

move_fonts(){
   sudo cp -v ~/auto_kitty/fonts/* ~/usr/share/fonts/ 2>&1
}

