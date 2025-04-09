{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = inputs: let
    hostname = "aura";
  in {
    nixosConfigurations."${hostname}" = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [{networking.hostName = "${hostname}";} ./hardware ./configuration ./software];
    };
  };
}
