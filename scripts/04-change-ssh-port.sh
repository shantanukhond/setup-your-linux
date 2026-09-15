#!/bin/bash
# Change SSH from port 22 to a port you choose, then check it is listening.
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

read -r -p "New SSH port: " PORT
if [ -z "$PORT" ] || [ "$PORT" = "22" ]; then
  echo "Pick a port other than 22."
  exit 1
fi

ufw allow "$PORT"/tcp

if grep -qE "^#?Port " /etc/ssh/sshd_config; then
  sed -i "s/^#\?Port .*/Port $PORT/" /etc/ssh/sshd_config
else
  echo "Port $PORT" >> /etc/ssh/sshd_config
fi

sed -i "s/^#\?PasswordAuthentication .*/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i "s/^#\?PermitRootLogin .*/PermitRootLogin no/" /etc/ssh/sshd_config

systemctl disable --now ssh.socket 2>/dev/null || true
systemctl restart ssh 2>/dev/null || systemctl restart sshd

sleep 1
if ss -tln | grep -q ":$PORT"; then
  echo "SSH is listening on port $PORT."
else
  echo "SSH did not start on port $PORT. Check /etc/ssh/sshd_config."
  exit 1
fi
