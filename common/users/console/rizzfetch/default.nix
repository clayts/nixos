{pkgs, ...}: let
  pythonEnv = pkgs.python313.withPackages (ps:
    with ps; [
      terminaltexteffects
    ]);
in {
  home.packages = [
    (pkgs.writeScriptBin "rizzfetch" ''
      export PATH=${pkgs.lib.makeBinPath [pkgs.toilet]}:$PATH
      exec ${pythonEnv}/bin/python ${./rizzfetch.py} "$@"
    '')
  ];
}
