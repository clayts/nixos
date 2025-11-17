#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Error: Script requires exactly one argument (disk)"
    echo "Usage: $0 <disk>"
    echo "Example: $0 /dev/sda"
    exit 1
fi

DISK="$1"

if [ ! -b "$DISK" ]; then
    echo "Error: '$DISK' is not a valid block device"
    exit 1
fi

read -p "Enter the name of this system: " HOSTNAME
if [[ -z "$HOSTNAME" ]]; then
    echo "Error: name cannot be blank"
    exit 1
fi

if [ -d "$HOSTNAME" ]; then
    echo "Using existing configuration..."
else
	echo "Creating new system..."

	mkdir $HOSTNAME

	echo """

	{...}: {
	  imports = [
	  	./hardware.nix
	    ./disks.nix

	    ../common/os
	    ../common/users
	  ];
	}

	""" > $HOSTNAME/default.nix

	echo "Generating disks.nix and hardware.nix..."
	sudo nixos-generate-config --show-hardware-config --no-filesystems > $HOSTNAME/hardware.nix

	SWAP_SIZE="$(free -m | awk '/^Mem:/{print $2 * 2}')M"

	echo """

	{inputs, ...}: {
	  imports = [
	    inputs.disko.nixosModules.disko
	  ];

	  disko.devices = {
	    disk = {
	      main = {
	        device = \"$DISK\";
	        type = \"disk\";
	        content = {
	          type = \"gpt\";
	          partitions = {
	            boot = {
	              type = \"EF00\";
	              size = \"1G\";
	              content = {
	                type = \"filesystem\";
	                format = \"vfat\";
	                mountpoint = \"/boot\";
	                mountOptions = [\"umask=0077\"];
	              };
	            };
	            swap = {
	              size = \"$SWAP_SIZE\";
	              content = {
	                type = \"swap\";
	                discardPolicy = \"both\";
	                resumeDevice = true;
	              };
	            };
	            root = {
	              size = \"100%\";
	              content = {
	                type = \"filesystem\";
	                format = \"ext4\";
	                mountpoint = \"/\";
	              };
	            };
	          };
	        };
	      };
	    };
	  };
	}


	""" > $HOSTNAME/disks.nix

	git add $HOSTNAME
fi

echo "Check the files in $HOSTNAME"
read -p "Press enter to continue or CTRL+C to abort" READY

echo "Installing..."
sudo nix --extra-experimental-features nix-command  --extra-experimental-features flakes run github:nix-community/disko/latest#disko-install -- --write-efi-boot-entries --flake .#$HOSTNAME --disk main $DISK

sudo nix --extra-experimental-features nix-command  --extra-experimental-features flakes run github:nix-community/disko/latest#disko -- --flake .#$HOSTNAME --mode mount

sudo cp -R . /mnt/etc/nixos

sudo nixos-enter --root /mnt -c """
echo 'set root password:'
passwd root
echo 'set user password:'
passwd user
echo 'set guest password:'
passwd guest
chown -R user:users /etc/nixos
rizzlefetch
"""

echo "*** Installation Complete! ***"
