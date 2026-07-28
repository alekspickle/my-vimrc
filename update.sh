#!/bin/bash

# update system packages
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

# update flatpak packages
flatpak update -y

# update rust, mostly to sync nightly
rustup update

# update nvim packages with vim.pack
nvim --headless -c "lua vim.pack.update()" -c "qa"

fwupdmgr get-updates && fwupdmgr update
