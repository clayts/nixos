{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = inputs: let
    nixpkgs = inputs.nixpkgs;
    systems =
      nixpkgs.lib.genAttrs
      ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
  in {
    # Dev
    devShells = systems (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          nixd
        ];
      };
    });

    # NixOS
    nixosConfigurations = with builtins;
      mapAttrs (hostname: _:
        nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [{networking.hostName = "${hostname}";} ./hardware/${hostname}];
        }) (readDir ./hardware);
  };
}
