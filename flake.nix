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
              superhtml
              basedpyright
              python313Packages.terminaltexteffects
              toilet
            ];
          };
        }
      );
    nixosConfigurations = with builtins; let
      machines =
        filter
        (path: pathExists (./. + "/${path}/default.nix"))
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
