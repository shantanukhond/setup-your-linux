#!/bin/bash
# Create a sudo user (no password) and set up an SSH key.
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

read -r -p "Sudo username: " USERNAME
if [ -z "$USERNAME" ]; then
  echo "Username is required."
  exit 1
fi

if id "$USERNAME" >/dev/null 2>&1; then
  echo "User $USERNAME already exists, updating sudo and SSH key."
else
  adduser --disabled-password --gecos "" "$USERNAME"
fi

usermod -aG sudo "$USERNAME"
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USERNAME"
chmod 440 "/etc/sudoers.d/$USERNAME"

if command -v zsh >/dev/null; then
  chsh -s "$(command -v zsh)" "$USERNAME"
  sudo -u "$USERNAME" -H sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

read -r -p "Paste SSH public key: " SSH_KEY
if [ -z "$SSH_KEY" ]; then
  echo "SSH key is required."
  exit 1
fi

mkdir -p "/home/$USERNAME/.ssh"
echo "$SSH_KEY" > "/home/$USERNAME/.ssh/authorized_keys"
chmod 700 "/home/$USERNAME/.ssh"
chmod 600 "/home/$USERNAME/.ssh/authorized_keys"
chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.ssh"

echo "User $USERNAME is ready (passwordless sudo + SSH key)."
