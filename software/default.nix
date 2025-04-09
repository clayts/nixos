{pkgs, ...}: let
  # installs all scripts in ./scripts as packages
  scriptPackages = map (name:
    pkgs.writeScriptBin
    (builtins.baseNameOf (pkgs.lib.removeSuffix ".sh" name))
    (builtins.readFile (./scripts + "/${name}")))
  (builtins.attrNames (builtins.readDir ./scripts));
  desktopPackages = with pkgs; [
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
    loupe
    file-roller
    gnome-calculator
    gnome-system-monitor
    gnome-characters
    gnome-calendar
    gnome-logs
    nautilus
    celluloid
    gnome-firmware
    gitg
    zed-editor
  ];
  shellPackages = with pkgs; [
    fzf
    lsd
    fd
    zoxide
    pciutils
    lshw
    git
    gh
    bat
  ];
in {
  imports = [
    ./firefox.nix
    ./steam.nix
    # ./boxes.nix
    # ./ai.nix
  ];
  environment.systemPackages = scriptPackages ++ shellPackages ++ desktopPackages;
}
