{pkgs, ...}: {
  environment.systemPackages = [
    (map (name:
      pkgs.writeScriptBin
      (builtins.baseNameOf (pkgs.lib.removeSuffix ".sh" name))
      (builtins.readFile (./scripts + "/${name}")))
    (builtins.attrNames (builtins.readDir ./scripts)))
  ];
}
