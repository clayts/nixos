# Migration

1. Partition the disk if necessary.
1. Mount the destination root filesystem at `/mnt`:

    ```bash
    sudo mount /dev/disk/by-partlabel/root /mnt
    ```

1. Mount the boot filesystem at `/mnt/boot`

    ```bash
    sudo mkdir /mnt/boot
    sudo mount -o umask=077 /dev/disk/by-partlabel/boot /mnt/boot
    ```

1. Activate swap, if necessary:

    ```bash
    sudo swapon /dev/disk/by-partlabel/swap
    ```

1. Mount other partitions, if necessary.
1. Get this flake:

    ```bash
    nix \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes \
    run nixpkgs#github-cli -- auth login
    git clone https://github.com/clayts/nixos && cd nixos
    ```

1. Scan hardware and push changes so they aren't lost:

    ```bash
    nixos-generate-config --root /mnt \
    --show-hardware-config > hardware/system.nix
    git commit -am "migration" && git push
    ```

1. Install:

    ```bash
    sudo nixos-install --flake .#os --root /mnt
    ```

1. Reboot

# To Do

- Cheese
- Howdy
- Check out:
	- setzer: latex editor
  - LMMS: music studio
  - gcompris: games for 2-10 year olds
