{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = inputs: let
    hostname = "aura";

    systems =
      inputs.nixpkgs.lib.genAttrs
      ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
  in {
    nixosConfigurations."${hostname}" = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [{networking.hostName = "${hostname}";} ./hardware ./configuration ./software];
    };

    # Dev
    devShells = systems (system: let
      pkgs = import inputs.nixpkgs {inherit system;};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          nixd
          alejandra
        ];
      };
    });
  };
}
