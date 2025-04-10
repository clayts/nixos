# Migration
1. Partition the disk if necessary.
2. Mount the destination root filesystem at `/mnt`:

        sudo mount /dev/disk/by-partlabel/root /mnt
3. Mount the boot filesystem at `/mnt/boot`

        sudo mkdir /mnt/boot
        sudo mount -o umask=077 /dev/disk/by-partlabel/boot /mnt/boot
4. Activate swap, if necessary:

        sudo swapon /dev/disk/by-partlabel/swap
5. Mount other partitions, if necessary.
7. Get this flake:

        nix --extra-experimental-features nix-command --extra-experimental-features flakes run nixpkgs#github-cli -- auth login
        git clone https://github.com/clayts/nixos
        cd nixos
8. Scan hardware:

        nixos-generate-config --root /mnt --show-hardware-config > hardware/system.nix
        git add .
        git commit -am "migration"
        git push
16. Install:

        sudo nixos-install --flake .#os --root /mnt
17. Reboot

# To Do
- Cheese
- Howdy
- Custom boot logo
- Make firefox initial window size constant
- Check out:
    - setzer: latex editor
    - LMMS: music studio
    - gcompris: games for 2-10 year olds
