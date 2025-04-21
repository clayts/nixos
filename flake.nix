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
    nixosConfigurations = builtins.mapAttrs (hostname: _:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs hostname;};
        modules = [./systems];
      }) (builtins.readDir ./systems);
  };
}
