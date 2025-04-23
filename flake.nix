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
  };
  outputs = inputs: {
    nixosConfigurations = with builtins; let
      systems =
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
      inputs.nixpkgs.lib.genAttrs systems os;
  };
}
