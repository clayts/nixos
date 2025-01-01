{pkgs, ...}: let
  # Helper function to read and convert a script file to a package
  scriptToPackage = name:
    pkgs.writeScriptBin
    (builtins.baseNameOf (pkgs.lib.removeSuffix ".sh" name))
    (builtins.readFile (./scripts + "/${name}"));

  # Get list of files in ./scripts directory
  scriptFiles = builtins.attrNames (builtins.readDir ./scripts);

  # Convert all script files to packages
  scriptPackages = map scriptToPackage scriptFiles;
in {
  imports = [
    ./firefox.nix
    ./games.nix
    ./desktop.nix
    ./shell.nix
    ./boxes.nix
  ];
  environment.systemPackages = scriptPackages;
}
