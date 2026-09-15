#!/bin/bash
# Run every setup step in order.
set -e

cd "$(dirname "$0")"

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root: sudo ./setup-server.sh"
  exit 1
fi

echo "setup-your-server"
echo "  1. update / upgrade"
echo "  2. install zsh"
echo "  3. create sudo user + SSH key"
echo "  4. change SSH port"
echo "  5. enable firewall"
echo "  6. install docker"
echo "  7. generate server SSH key"
echo

./scripts/01-update-upgrade.sh
./scripts/02-install-zsh.sh
./scripts/03-create-user.sh
./scripts/04-change-ssh-port.sh
./scripts/05-enable-firewall.sh
./scripts/06-install-docker.sh
./scripts/07-generate-ssh-key.sh

echo
echo "Done. Stay on this session until you can log in on the new SSH port."
