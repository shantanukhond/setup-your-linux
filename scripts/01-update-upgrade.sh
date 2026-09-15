#!/bin/bash
# Update packages and install a few basics.
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y
apt-get install -y sudo curl ca-certificates ufw

echo "Packages updated."
