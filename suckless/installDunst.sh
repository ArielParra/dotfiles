#!/bin/env bash

# Download necesary packages, if they are install they wont download,kinda bloated but works

packagesArch=("git" "base-devel" "libx11" "libxft" "libxinerama" "freetype2" "fontconfig")
packagesDebian=("git" "build-essential" "libx11-dev" "libxft-dev" "libxinerama-dev" "libfreetype6-dev" "libfontconfig1-dev")
packagesVoid=("git" "base-devel" "libX11-devel" "libXft-devel" "libXinerama-devel" "freetype-devel" "fontconfig-devel")

if command -v pacman &> /dev/null; then
    # Arch Linux
    packages=("${packagesArch[@]}")
elif command -v apt-get &> /dev/null; then
    # Debian-based 
    packages=("${packagesDebian[@]}")
elif command -v xbps-install &> /dev/null; then
    # Void Linux
    packages=("${packagesVoid[@]}")
else
    echo "Unsupported distribution."
    exit 1
fi

for package in "${packages[@]}"; do
    if command -v pacman &> /dev/null; then
        if ! pacman -Qe | grep -qw "$package";then
            if ! which "$package" &> /dev/null; then
                sudo pacman -S --noconfirm "$package"
            else
                echo "$package is already installed."
            fi
        else
            echo "$package is already installed."
        fi
    elif command -v apt-get &> /dev/null; then
        if ! dpkg -l | grep -qw "$package"; then
            if ! which "$package" &> /dev/null; then
                sudo apt-get install -y "$package"
            else
                echo "$package is already installed."
            fi

        else
            echo "$package is already installed."
        fi
    elif command -v xbps-install &> /dev/null; then
        if ! xbps-query -l | grep -qw "$package"; then
            if ! which "$package" &> /dev/null; then
                sudo xbps-install -y "$package"
            else
                echo "$package is already installed."
            fi
        else
            echo "$package is already installed."
        fi
    fi
done

# clone suckless repos, if fail exit, and next time continue where it left

clone_repository() {
    if [ -d "$2" ]; then
        echo "Destination path '$2' already exists. Checking if it's an empty directory."
        if [ "$(ls -A "$2")" ]; then
            echo "Destination path '$2' is not an empty directory. Skipping clone for $1."
            return
        else
            echo "Destination path '$2' exists but is empty. Continuing with clone."
        fi
    else
        mkdir -p "$2"
        echo "Created destination path '$2'."
    fi

    git clone "$1" "$2"

    # Check if the git clone command was successful
    if [ $? -ne 0 ]; then
        echo "Git clone failed for $1. Exiting."
        exit 1
    fi

    echo "Git clone successful for $1 into '$destination'."
}


clone_repository https://github.com/dunst-project/dunst.git dunst/

rm -r -d -f dunst/.git/

cp configs/dunstrc dunst/dunstrc
echo "compiling dunst and installing them on the system"

cd dunst
make WAYLAND=0
sudo make WAYLAND=0 install
