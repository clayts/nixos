#!/bin/sh

# The bootstrap.sh script is intended to be executed from a NixOS livecd on the destination computer.

# To run this script, follow these steps:
# 1. Partition the disk if necessary.
# 2. Mount the destination root filesystem at /mnt:
#     sudo mount /dev/disk/by-partlabel/linux-root /mnt
# 3. Mount the boot filesystem at /mnt/boot
#     sudo mkdir /mnt/boot
#     sudo mount -o umask=077 /dev/disk/by-partlabel/boot /mnt/boot
# 4. Activate swap, if necessary:
#     sudo swapon /dev/disk/by-partlabel/linux-swap
# 5. Mount other partitions, if necessary.
# 6. nix --extra-experimental-features nix-command --extra-experimental-features flakes run nixpkgs#gh auth login
# 7. git clone https://github.com/clayts/NixOS
# 8. Finally, run ./bootstrap.sh <HOSTNAME>

if [ $# -ne 1 ];then
	echo "Usage: bootstrap.sh <HOSTNAME>"
	exit
fi

hostname=$1
cd $(dirname "$0") &&
mkdir -p hosts/$hostname &&
nixos-generate-config --root /mnt --show-hardware-config > hosts/$hostname/hardware-scan.nix &&
echo """
{...}: {
  imports = [
    ./hardware-scan.nix
    ../../hardware/standard 

    ../../os
    ../../desktop
    ../../apps
  ];
}
""" > hosts/$hostname/default.nix &&
nano hosts/$hostname/default.nix &&
git add . &&
sudo nixos-install --flake .#$hostname --root /mnt &&
git commit -am "Bootstrapped $hostname ($(date))" &&
git push

