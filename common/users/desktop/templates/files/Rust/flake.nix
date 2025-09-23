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
            # LD_LIBRARY_PATH = with pkgs;
            #   lib.makeLibraryPath [
            #     libGL
            #     libxkbcommon
            #     wayland
            #     vulkan-loader
            #   ];
            packages = with pkgs; [
              nixd
              alejandra
              rustc # Rust compiler
              cargo # Rust package manager
              rustfmt # Code formatter
              clippy # Linter
              rust-analyzer # Language server for IDE support
              llvmPackages.bintools
              # trunk
              # package-version-server
              pkg-config
              # alsa-lib.dev
              # gnuplot
            ];
          };
        }
      );
  };
}
