{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
        LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
          # libGL
          # libxkbcommon
          wayland
        ];
        packages = with pkgs; [
          rustc # Rust compiler
          cargo # Rust package manager
          # rustfmt        # Code formatter
          # clippy         # Linter
          # rust-analyzer  # Language server for IDE support
        ];
      };
    });
  };
}
