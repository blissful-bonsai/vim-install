#!/bin/bash
echo -e "\n"
echo -e "This script is intended for macOS and Linux distributions that use the apt, dnf, or pacman package managers.\n"
echo -e "On macOS, git and vim are installed by default.\n"
echo "Press any key to continue"
read -n 1 -s


# Package installation
function installation(){
    echo "The installer will ask you to input your password now."
    packages="vim git"
    if [ -x "$(command -v apt)" ]; then
        sudo apt update && sudo apt install $packages
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf update && sudo dnf install $packages
    elif [ -x "$(command -v pacman)" ]; then
        sudo pacman -Syu $packages
    else
        echo "It seems like this script does not support your distro or operating system."
        exit 1
    fi
}

# This function checks whether or not the user is running macOS, if so, vim and git are probably already installed
kernel_name=$(uname -s)
function check_os(){
    if [ "$kernel_name" = "Darwin" ]; then
        echo "You are running macOS. Chances are, vim and git are already installed!"
    else
        installation
    fi
}
check_os

# General configuration
echo "set tabstop=4" >> ~/.vimrc
echo "set shiftwidth=4" >> ~/.vimrc
echo "set expandtab" >> ~/.vimrc
echo "set number" >> ~/.vimrc
echo "syntax enable" >> ~/.vimrc

# Color selection
echo -e "Please, select a color theme\n0 - Dracula\n1 - Gruvbox."

while true; do
    read -p "Enter your choice: " user_choice
    
    if [[ "$user_choice" =~ ^[0-1]$ ]]; then
        break
    else
        echo "Invalid choice. Please enter 0 or 1."
    fi
done

if [ "$user_choice" -eq 0 ]; then
    chosen_theme="dracula"
    if [ ! -d ~/.vim/pack/themes/start/dracula ]; then
        mkdir -p ~/.vim/pack/themes/start
        cd ~/.vim/pack/themes/start
        git clone https://github.com/dracula/vim.git dracula
    fi

elif [ "$user_choice" -eq 1 ]; then
    chosen_theme="gruvbox"
    if [ ! -d ~/.vim/pack/themes/start/gruvbox ]; then
        echo "Please keep in mind that the Gruvbox theme offers both dark and light themes, along with contrast options for each theme variant. Refer to their GitHub page for more information."
        echo "Press any key to continue"
        read -n 1 -s
        mkdir -p ~/.vim/pack/themes/start
        cd ~/.vim/pack/themes/start
        git clone https://github.com/morhetz/gruvbox.git gruvbox
    fi
fi

echo "packadd! $chosen_theme" >> ~/.vimrc
echo "colorscheme $chosen_theme" >> ~/.vimrc
echo "$chosen_theme is the default Vim theme now!"
