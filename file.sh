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
    apt update -y >/dev/null 2>&1 && apt upgrade -y >/dev/null 2>&1
    echo -e "${greenColour}[✓] System upgrades checked.${endColour}\n"
}

# Install kitty
install_kitty(){
    echo -e "${blueColour}[+] Installing Kitty and Zsh...${endColour}"
    apt install -y kitty zsh >/dev/null 2>&1
    echo -e "${greenColour}[✓] Kitty installed.${endColour}\n"
}

# Move the fonts
move_fonts(){
    echo -e "${blueColour}[+] Moving fonts...${endColour}"

    if [ -d "$ruta/fonts" ]; then
        cp -r "$ruta/fonts/"* /usr/share/fonts/ >/dev/null 2>&1
        fc-cache -fv >/dev/null 2>&1
        echo -e "${greenColour}[✓] Fonts installed successfully.${endColour}\n"
    else
        echo -e "${redColour}[!] Fonts directory not found: $ruta/fonts${endColour}\n"
    fi
}

# Create kitty files
create_kitty_files(){
    echo -e "${blueColour}[+] Creating kitty files...${endColour}"

    mkdir -p /home/$USER/.config/kitty >/dev/null 2>&1
    mkdir -p /root/.config >/dev/null 2>&1

    if [ -d "$ruta/config_kitty" ]; then
        cp -r "$ruta/config_kitty/"* /home/$SUDO_USER/.config/kitty/ >/dev/null 2>&1
        sudo cp -r "$ruta/config_kitty/"* /root/.config/ >/dev/null 2>&1
        echo -e "${greenColour}[✓] Kitty ready to run.${endColour}\n"
    else
        echo -e "${redColour}[!] Config directory not found: $ruta/config_kitty${endColour}\n"
    fi
}


# Install p10k
p10k_install(){
    echo -e "${blueColour}[+] Installing p10k...${endColour}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
    echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k
}



# Execution
#----------------------------------------------
check_root_user
update_system
install_kitty
move_fonts
create_kitty_files
p10k_install
