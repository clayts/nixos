{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs: {
    nixosConfigurations =
      builtins.mapAttrs (name: value: (inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          {networking.hostName = "${name}";}
          ./hosts/${name}
        ];
      }))
      (builtins.readDir
        ./hosts);
  };
}
