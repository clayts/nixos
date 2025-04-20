#!/usr/bin/env bash

set -euo pipefail

if [[ "$1" == "--finish" ]]; then
    # Run your commands here
    echo "Finishing up..."
    echo "Set password for guest:"
    passwd guest

    echo "Set password for user:"
    passwd user

    echo "Granting ownership of /etc/nixos"
    chown -R user:users /etc/nixos

    echo "Installation complete!"

    exit 0
fi

echo """
WARNING! This script should only be run from a liveUSB, on a system which has been prepared appropriately.

- The root partition must be unmounted, and available at /dev/disk/by-partlabel/root.
- The boot partition must be unmounted, and available at /dev/disk/by-partlabel/boot.
- If a swap partition is desired, it must be deactivated and available at /dev/disk/by-partlabel/swap.
"""

# Get hostname from user
read -p "Enter hostname for this system: " HOSTNAME
if [[ -z "$HOSTNAME" ]]; then
    echo "Error: Hostname cannot be empty"
    exit 1
fi

# Function to create initial hardware configuration directory
create() {
    mkdir -p "hardware/$HOSTNAME"
    echo """
    {...}: {
      imports = [
        ./platform.nix
      ];
    }
    """ > "hardware/$HOSTNAME/default.nix"
}

# Mount filesystems by partlabel
echo "Mounting filesystems..."
if ! sudo mount /dev/disk/by-partlabel/root /mnt; then
    echo "Error: Failed to mount root filesystem"
    exit 1
fi

if [ ! "$(ls /mnt)" = "lost+found" ]; then
    echo "Error: root filesystem is not empty"
    exit 1
fi

sudo mkdir /mnt/boot
if ! sudo mount -o umask=077 /dev/disk/by-partlabel/boot /mnt/boot; then
    echo "Error: Failed to mount boot filesystem"
    exit 1
fi

# Activate swap if it exists
if [[ -e /dev/disk/by-partlabel/swap ]]; then
    echo "Activating swap..."
    sudo swapon /dev/disk/by-partlabel/swap
fi

# Move configuration to /etc/nixos
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
echo "Moving configuration files..."
sudo mv "$SCRIPT_DIR" /mnt/etc/nixos
cd /mnt/etc/nixos

# Create or update hardware configuration
if [[ ! -d "hardware/$HOSTNAME" ]]; then
    create
fi

echo "Scanning hardware..."
sudo nixos-generate-config --root /mnt --show-hardware-config > "hardware/$HOSTNAME/platform.nix"

read -p """
Check the configuration in /mnt/hardware/$HOSTNAME before continuing!

Press enter to install when ready
"""

# Install NixOS
echo "Installing NixOS..."
if ! sudo nixos-install --flake .#$HOSTNAME --root /mnt; then
    echo "Error: Installation failed"
    exit 1
fi

echo """
Success!

Reboot, log in as root and run

/etc/nixos/install.sh --finish
"""
