#!/bin/bash
# Generate an SSH key on this server (for GitHub, git clone, etc.).
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

read -r -p "Username: " USERNAME
if [ -z "$USERNAME" ]; then
  echo "Username is required."
  exit 1
fi

if ! id "$USERNAME" >/dev/null 2>&1; then
  echo "User $USERNAME does not exist."
  exit 1
fi

SSH_DIR="/home/$USERNAME/.ssh"
KEY="$SSH_DIR/id_ed25519"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
chown "$USERNAME:$USERNAME" "$SSH_DIR"

if [ -f "$KEY" ]; then
  echo "SSH key already exists for $USERNAME."
else
  sudo -u "$USERNAME" ssh-keygen -t ed25519 -f "$KEY" -C "$USERNAME@$(hostname)" -N ""
fi

chmod 600 "$KEY"
chmod 644 "$KEY.pub"
chown "$USERNAME:$USERNAME" "$KEY" "$KEY.pub"

echo
echo "Public key (add this to GitHub):"
cat "$KEY.pub"
