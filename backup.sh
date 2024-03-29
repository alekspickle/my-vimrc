#!/bin/bash 

# cleer previoous buckups
sudo rm -rf /var/backups/Documents
sudo rm -rf /var/backups/Downloads
sudo rm -rf /var/backups/Videos
sudo rm -rf /var/backups/Pictures
sudo rm -rf /var/backups/lmms

# backup most of the data
sudo rsync -avzh /home/pickle/Documents /var/backups/ --exclude "*/target/*" --exclude "*/Fyrox/*"  --exclude "*/node_modules/*" --exclude "*.git*" --max-size=5M
sudo rsync -avzh /home/pickle/Downloads /var/backups/ --exclude "Telegram" --exclude "Telegram Desktop" --max-size=5M
sudo rsync -avzh /home/pickle/Videos /var/backups/ --max-size=15M
sudo rsync -avzh /home/pickle/Pictures /var/backups/ --max-size=10M
sudo rsync -avzh /home/pickle/lmms /var/backups/ --max-size=15M
rsync -avzh /home/pickle/.config/nvim /home/pickle/Documents/my-vimrc --exclude "*site*" --exclude "*plugin*" --max-size=200K
rsync -avzh /home/pickle/.config/alacritty/alacritty.yml /home/pickle/Documents/my-vimrc/alacritty.yml
