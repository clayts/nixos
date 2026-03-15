{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
              nixd
              alejandra
              package-version-server
              vscode-langservers-extracted
              superhtml
              basedpyright
              python313Packages.terminaltexteffects
              toilet
              ruff
              (pkgs.writeShellScriptBin "clean" ''nh clean all -k 3 && nix-store --optimise'')
              (pkgs.writeShellScriptBin "switch" ''nh os switch /etc/nixos'')
              (pkgs.writeShellScriptBin "update" ''
                cd /etc/nixos &&
                nix flake update &&
                if [ -z "$(git status --porcelain ./flake.lock)" ]; then
                    echo "No update." && exit 1
                else
                    git commit ./flake.lock -m "Update $(date)"
                fi
              '')
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
