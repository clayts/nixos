{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:DiogoDoreto/nixpkgs/unstable-ipu7-webcam";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme/master";
      flake = false;
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: {
    devShells =
      inputs.nixpkgs.lib.genAttrs
      ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"] (
        system: let
          pkgs = import inputs.nixpkgs {inherit system;};
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              (pkgs.writeShellScriptBin "nixos-clean" ''
                nh clean all -k 3 && nix-store --optimise
              '')
              (pkgs.writeShellScriptBin "nixos-switch" ''
                nh os switch /etc/nixos
              '')
              (pkgs.writeShellScriptBin "nixos-update" ''
                cd /etc/nixos &&

                # Update flake.lock
                nix flake update &&

                # If nothing changed,
                if [ -z "$(git status --porcelain ./flake.lock)" ]; then
                    # We're finished here.
                    echo "No update." && exit 1
                else
                    # Commit these updates.
                    git commit ./flake.lock -m "Update $(date)"
                fi
              '')
              nixd
              alejandra
              superhtml
              basedpyright
              python313Packages.terminaltexteffects
              toilet
              ruff
            ];
          };
        }
      );
    nixosConfigurations = with builtins; let
      machines =
        filter
        (directory: pathExists (./. + "/${directory}/default.nix"))
        (attrNames (readDir ./.));
      os = name:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./${name}
            {networking.hostName = name;}
          ];
        };
    in
      inputs.nixpkgs.lib.genAttrs machines os;
  };
}
