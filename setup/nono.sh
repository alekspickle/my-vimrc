#!/bin/bash

VERSION=$(curl -sI https://github.com/always-further/nono/releases/latest | grep -i location | grep -oP 'v\K[0-9.]+')
ARCH=$(dpkg --print-architecture)
wget https://github.com/always-further/nono/releases/download/v${VERSION}/nono-cli_${VERSION}_${ARCH}.deb
sudo dpkg -i nono-cli_${VERSION}_${ARCH}.deb
