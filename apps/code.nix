{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Coding
    (pkgs.vscode-with-extensions.override {
      vscode = pkgs.vscodium;
      vscodeExtensions = let
        extensions = inputs.nix-vscode-extensions.extensions."${pkgs.stdenv.hostPlatform.system}".vscode-marketplace;
      in
        with extensions; [
          eliverlara.andromeda
          file-icons.file-icons
          jnoortheen.nix-ide
          mhutchie.git-graph
        ];
    })
    alejandra
    nil
    git
    gh
  ];
}
