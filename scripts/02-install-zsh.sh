#!/bin/bash
# Install zsh and Oh My Zsh.
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

apt-get install -y zsh git

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "zsh and Oh My Zsh installed."
