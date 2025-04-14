{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "iotas-with-dictionaries";
      paths = with pkgs; [
        iotas
      ];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/iotas \
          --set ASPELL_CONF "dict-dir ${pkgs.aspellDicts.en}/lib/aspell"
      '';
    })
  ];
}
