#!/usr/bin/env bash

set -euo pipefail

read -p "Enter hostname for this system: " HOSTNAME
if [[ -z "$HOSTNAME" ]]; then
    echo "Error: Hostname cannot be blank"
    exit 1
fi

echo
lsblk
echo

read -p "Enter target disk: " DISK
if [[ -z "$DISK" ]]; then
    echo "Error: Disk cannot be blank"
    exit 1
fi

DISK_ID="$(ls -l /dev/disk/by-id/ | grep "$DISK$" | awk '{print $9}' | head -1)"

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

{disko, ...}: {
  imports = [
    disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/$DISK_ID";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            swap = {
              size = "$SWAP_SIZE";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
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
sudo nix run github:nix-community/disko/latest#disko-install -- --flake .#$HOSTNAME

#move source into /mnt/etc/nixos
#change owner
#set passwords
