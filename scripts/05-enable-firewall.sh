#!/bin/bash
# Enable the firewall and allow SSH.
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

read -r -p "SSH port to allow: " PORT
if [ -z "$PORT" ]; then
  echo "SSH port is required."
  exit 1
fi

ufw default deny incoming
ufw default allow outgoing
ufw allow "$PORT"/tcp
ufw --force enable
ufw status

echo "Firewall enabled. SSH port $PORT is allowed."
