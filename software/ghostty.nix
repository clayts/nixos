{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "ghostty-no-stderr";
      paths = [pkgs.ghostty];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/ghostty \
          --run 'exec "$@" 2> /dev/null' \
          --argv0 ""
      '';
    })
  ];
}
