{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
              python314
              basedpyright
            ];
          };
        }
      );
  };
}
