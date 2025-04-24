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

read -p "Enter hostname for this system: " HOSTNAME
if [[ -z "$HOSTNAME" ]]; then
    echo "Error: Hostname cannot be blank"
    exit 1
fi

SWAP_SIZE="$(free -m | awk '/^Mem:/{print $2 * 2}')M"

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

sudo nixos-generate-config --show-hardware-config --no-filesystems > $HOSTNAME/hardware.nix

echo """

{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      main = {
        device = \"\";
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

echo "Check the files in $HOSTNAME"
read -p "Press enter to continue or CTRL+C to abort" READY

echo "Installing..."
sudo nix --extra-experimental-features nix-command  --extra-experimental-features flakes run github:nix-community/disko/latest#disko-install -- --flake .#$HOSTNAME --disk main $DISK

#move source into /mnt/etc/nixos
#change owner
#set passwords
