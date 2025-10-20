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

ruta=$(pwd) 

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

    target_user=${SUDO_USER:-$USER}

    mkdir -p "/home/$target_user/.config/kitty" >/dev/null 2>&1
    mkdir -p /root/.config >/dev/null 2>&1

    if [ -d "$ruta/config_kitty" ]; then
        cp -r "$ruta/config_kitty/"* "/home/$target_user/.config/kitty/" >/dev/null 2>&1
        cp -r "$ruta/config_kitty/"* /root/.config/ >/dev/null 2>&1
        echo -e "${greenColour}[✓] Kitty ready to run.${endColour}\n"
    else
        echo -e "${redColour}[!] Config directory not found: $ruta/config_kitty${endColour}\n"
    fi
}

p10k_install(){
    echo -e "${blueColour}[+] Installing p10k...${endColour}"

    target_user=${SUDO_USER:-$USER}
    if [ "$target_user" = "root" ]; then
        user_home="/root"
    else
        user_home=$(eval echo "~$target_user")
    fi

    user_repo="$user_home/.powerlevel10k"
    root_repo="/root/.powerlevel10k"

    # -- Usuario (invocador)
    if [ -d "$user_repo/.git" ]; then
        # actualizar si ya existe
        git -C "$user_repo" pull --quiet >/dev/null 2>&1 || true
    else
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$user_repo" >/dev/null 2>&1 || true
        # ajustar propietario si estamos como root y el usuario no es root
        if [ "$target_user" != "root" ]; then
            chown -R "$target_user:$target_user" "$user_repo" >/dev/null 2>&1 || true
        fi
    fi

    # asegurar que .zshrc del usuario contiene la línea source (añadir solo si falta)
    if [ -f "$user_home/.zshrc" ]; then
        if ! grep -qxF "source $user_repo/powerlevel10k.zsh-theme" "$user_home/.zshrc"; then
            echo "source $user_repo/powerlevel10k.zsh-theme" >> "$user_home/.zshrc"
            chown "$target_user:$target_user" "$user_home/.zshrc" >/dev/null 2>&1 || true
        fi
    else
        echo "source $user_repo/powerlevel10k.zsh-theme" > "$user_home/.zshrc"
        chown "$target_user:$target_user" "$user_home/.zshrc" >/dev/null 2>&1 || true
    fi

    # -- Root
    if [ -d "$root_repo/.git" ]; then
        git -C "$root_repo" pull --quiet >/dev/null 2>&1 || true
    else
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$root_repo" >/dev/null 2>&1 || true
    fi

    if [ -f /root/.zshrc ]; then
        if ! grep -qxF "source $root_repo/powerlevel10k.zsh-theme" /root/.zshrc; then
            echo "source $root_repo/powerlevel10k.zsh-theme" >> /root/.zshrc
        fi
    else
        echo "source $root_repo/powerlevel10k.zsh-theme" > /root/.zshrc
    fi

    echo -e "${greenColour}[✓] p10k installed/updated.${endColour}\n"
}

p10k_conf(){
    echo -e "${blueColour}[+] Installing p10k config...${endColour}"

    target_user=${SUDO_USER:-$USER}
    if [ "$target_user" = "root" ]; then
        user_home="/root"
    else
        user_home=$(eval echo "~$target_user")
    fi

    # si existe el archivo de config local en $ruta, lo copiamos a los homes correctos
    if [ -f "$ruta/.p10k.zsh" ]; then
        cp -f "$ruta/.p10k.zsh" "$user_home/.p10k.zsh" >/dev/null 2>&1 || true
        chown "$target_user:$target_user" "$user_home/.p10k.zsh" >/dev/null 2>&1 || true

        cp -f "$ruta/.p10k.zsh" /root/.p10k.zsh >/dev/null 2>&1 || true
        echo -e "${greenColour}[✓] p10k config copied to user and root.${endColour}\n"
    else
        echo -e "${yellowColour}[!] No .p10k.zsh found in $ruta, skipping config copy.${endColour}\n"
    fi
}

# Execution
#----------------------------------------------
check_root_user
update_system
install_kitty
move_fonts
create_kitty_files
p10k_install
p10k_conf