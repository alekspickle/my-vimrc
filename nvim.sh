#!/bin/bash

# Check if the "--sync" flag is present
# ./nvim --sync
if [[ "$*" == *"--sync"* ]]; then
    rsync -avzh ~/.config/nvim/ ./nvim/ --exclude="*site" --exclude="*plugin"
    exit 0;
fi

if [ -d "/squashfs-root" ]; then
    rm -rf /squashfs-root
    rm /usr/bin/nvim
#    rm -rf ~/.config/nvim
fi

if [ ! -f "nvim.appimage" ]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
fi

./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version

# Optional: exposing nvim globally.
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim

# clean up
rm ./nvim.appimage
mkdir ~/.config/nvim

# install packer
cd ~
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.config/nvim/site/pack/packer/start/packer.nvim

rsync -avzh ./nvim/ ~/.config/nvim/

