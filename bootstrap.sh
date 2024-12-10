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
# 6. sudo mkdir /mnt/etc
# 7. cd /mnt/etc
# 8. sudo nix --extra-experimental-features nix-command --extra-experimental-features flakes run nixpkgs#gh auth login 
# 9. open https://github.com/login/device and enter code
# 10. sudo git clone https://github.com/clayts/nixos
# 11. cd nixos
# 12. sudo sh -c "nixos-generate-config --root /mnt --show-hardware-config > hardware/<HOSTNAME>/scan.nix"
# 13. sudo nano hardware/<HOSTNAME>/default.nix
# 14. use the following as a starting point:
# {...}: {
#   imports = [
#     ./scan.nix
#     ../../devices/standard
# 
#     ../../os
#     ../../desktop
#     ../../apps
#   ];
# }
# 15. sudo git add .
# 16. sudo nixos-install --flake .#<HOSTNAME> --root /mnt
# 17. reboot
# 18. chown -R user /etc/nixos
# 19. chgrp -R users /etc/nixos
# 20. sudo systemctl start wallpaper-switcher.service
