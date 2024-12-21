{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = inputs: let
    nixpkgs = inputs.nixpkgs;
    systems =
      nixpkgs.lib.genAttrs
      ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
    shell = pkgs:
      pkgs.mkShell {
        packages = with pkgs; [
          # Shell packages
        ];
      };
    # TODO sort this out, must be linked to the readDir command
    os = hostname:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs hostname;};
        modules = [./hardware];
      };
  in {
    devShells = systems (system: {default = shell (import nixpkgs {inherit system;});});
    nixosConfigurations = with builtins; mapAttrs (name: _: (os name)) (readDir ./hardware);
  };
}
