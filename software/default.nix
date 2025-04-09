{pkgs, ...}: let
  # installs all scripts in ./scripts as packages
  scriptPackages = map (name:
    pkgs.writeScriptBin
    (builtins.baseNameOf (pkgs.lib.removeSuffix ".sh" name))
    (builtins.readFile (./scripts + "/${name}")))
  (builtins.attrNames (builtins.readDir ./scripts));
  desktopPackages = with pkgs; [
    ghostty
    loupe
    file-roller
    gnome-calculator
    gnome-system-monitor
    gnome-characters
    gnome-calendar
    nautilus
    celluloid
    gnome-firmware
    gitg
    # zed-editor
  ];
  shellPackages = with pkgs; [
    fzf
    lsd
    fd
    zoxide
    lnav
    pciutils
    lshw
    git
    gh
    bat
    alejandra
    nixd
  ];
in {
  imports = [
    ./firefox.nix
    ./steam.nix
    ./zed-fhs.nix
    # ./boxes.nix
    # ./ai.nix
  ];
  environment.systemPackages = scriptPackages ++ shellPackages ++ desktopPackages;
}
