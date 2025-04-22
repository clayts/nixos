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
    nixosConfigurations = builtins.mapAttrs (name: _:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./systems/${name}
          {networking.hostName = name;}
        ];
      }) (inputs.nixpkgs.lib.filterAttrs (n: _: builtins.pathExists (./systems + "/${n}/default.nix"))
      (builtins.readDir ./systems));
  };
}
