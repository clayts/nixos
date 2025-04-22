# To Do

- Cheese
- Howdy
- filter nixosConfigurations.*
- move star button=play button settings to aura

- Check out:
	- setzer: latex editor
  - LMMS: music studio
  - gcompris: games for 2-10 year olds


# Installation

1. Get this flake:

    ```bash
    nix \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes \
    run nixpkgs#github-cli -- auth login

    git clone https://github.com/clayts/nixos
    ```

1. Run `install.sh`:

    ```bash
   ./install.sh
    ```

1. Reboot

1. Switch to a terminal, log in as `root`, and run:

    ```bash
    passwd guest

    passwd user
    chown -R user:users /etc/nixos
    ```
