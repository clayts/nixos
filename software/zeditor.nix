{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nodejs
    (pkgs.stdenv.mkDerivation {
      pname = "zed-editor-with-langservers";
      version = pkgs.zed-editor.version;

      nativeBuildInputs = [pkgs.makeWrapper];

      buildCommand = ''
        mkdir -p $out/bin
        makeWrapper ${pkgs.zed-editor}/bin/zeditor $out/bin/zeditor \
          --prefix PATH : "${pkgs.vscode-langservers-extracted}/lib/node_modules/vscode-langservers-extracted/bin" \
          --prefix PATH : "${pkgs.tailwindcss-language-server}/bin" \
          --prefix PATH : "${pkgs.package-version-server}/bin" \
          --prefix PATH : "${pkgs.nixd}/bin" \
          --prefix PATH : "${pkgs.alejandra}/bin"
      '';

      inherit (pkgs.zed-editor) meta;
    })
  ];
}
