#!/bin/env bash

# Download necesary packages, if they are install they wont download,kinda bloated but works

packagesArch=("git" "curl" "base-devel" "libx11" "libxft" "libxinerama" "freetype2" "fontconfig")
packagesDebian=("git" "curl" "build-essential" "libx11-dev" "libxft-dev" "libxinerama-dev" "libfreetype6-dev" "libfontconfig1-dev")
packagesVoid=("git" "curl" "base-devel" "libX11-devel" "libXft-devel" "libXinerama-devel" "freetype-devel" "fontconfig-devel")

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


clone_repository https://git.suckless.org/st/ st/
clone_repository https://git.suckless.org/dwm dwm/
clone_repository https://git.suckless.org/slstatus slstatus/
clone_repository https://git.suckless.org/dmenu dmenu/

rm -r -d -f dwm/.git/
rm -r -d -f st/.git/
rm -r -d -f slstatus/.git/
rm -r -d -f dmenu/.git/

cp configs/config_dwm.h dwm/config.h
cp configs/config_st.h st/config.h
cp configs/config_slstatus.h slstatus/config.h
cp configs/config_dmenu.h dmenu/config.h


#installing st patches

cd st/
mkdir patches

cd patches/
echo "downloading patches for st"

patches=(
  "https://st.suckless.org/patches/alpha/st-alpha-20220206-0.8.5.diff"
  "https://st.suckless.org/patches/boxdraw/st-boxdraw_v2-0.8.5.diff"
  "https://st.suckless.org/patches/nordtheme/st-nordtheme-0.8.5.diff"
  "https://st.suckless.org/patches/scrollback/st-scrollback-0.8.5.diff"
  "https://st.suckless.org/patches/scrollback/st-scrollback-mouse-20220127-2c5edf2.diff"
  "https://st.suckless.org/patches/scrollback/st-scrollback-mouse-altscreen-20220127-2c5edf2.diff"
  "https://st.suckless.org/patches/clipboard/st-clipboard-0.8.3.diff"
  "https://st.suckless.org/patches/anysize/st-anysize-20220718-baa9357.diff"
)

for patch in "${patches[@]}"; do
  filename=$(basename "$patch")

  # Check if the file already exists
  if [ -e "$filename" ]; then
    echo "patch $filename already exists. Skipping."
  else
    echo "Downloading: $patch"
    curl -O "$patch"
    
    if [ $? -ne 0 ]; then
      echo "Download failed. Exiting."
      exit 1
    fi
  fi
done

cd ..

echo "Patches downloads scuccessfull. Applying patches"

git apply patches/st-boxdraw_v2-0.8.5.diff
patch -p1 < patches/st-alpha-20220206-0.8.5.diff
patch -p1 < patches/st-nordtheme-0.8.5.diff
patch -p1 < patches/st-scrollback-0.8.5.diff
patch -p1 < patches/st-scrollback-mouse-20220127-2c5edf2.diff
patch -p1 < patches/st-scrollback-mouse-altscreen-20220127-2c5edf2.diff
patch -p1 < patches/st-clipboard-0.8.3.diff
patch -p1 < patches/st-anysize-20220718-baa9357.diff

# compiling suckless apps
echo "compiling suckless apps and installing them on the system"

#still in st/ folder
make
sudo make clean install
cd ..
cd dwm
make
sudo make clean install
cd ..
cd dmenu
make
sudo make clean install
cd ..
cd slstatus
make
sudo make clean install
