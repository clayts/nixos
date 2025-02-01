{pkgs, ...}: let
  # installs all scripts in ./scripts as packages
  scriptPackages = map (name:
    pkgs.writeScriptBin
    (builtins.baseNameOf (pkgs.lib.removeSuffix ".sh" name))
    (builtins.readFile (./scripts + "/${name}")))
  (builtins.attrNames (builtins.readDir ./scripts));
in {
  imports = [
    ./firefox.nix
    ./games.nix
    ./desktop.nix
    ./shell.nix
    ./boxes.nix
    ./ai.nix
  ];
  environment.systemPackages = scriptPackages;
}
