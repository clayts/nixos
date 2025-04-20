{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nodejs
    (pkgs.symlinkJoin {
      name = "zed-editor-with-langservers";
      paths = with pkgs; [
        zed-editor
        tailwindcss-language-server
        package-version-server
        nixd
        alejandra
      ];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/zeditor \
          --prefix PATH : "${pkgs.vscode-langservers-extracted}/lib/node_modules/vscode-langservers-extracted/bin"
      '';
    })
  ];
}
