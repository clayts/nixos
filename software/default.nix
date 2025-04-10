{pkgs, ...}: let
  desktopPackages = with pkgs; [
    loupe
    file-roller
    gnome-calculator
    gnome-system-monitor
    gnome-characters
    gnome-calendar
    gnome-logs
    eyedropper
    nautilus
    celluloid
    gnome-firmware
    gitg
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
  scriptPackages = map (name:
    pkgs.writeScriptBin
    (builtins.baseNameOf (pkgs.lib.removeSuffix ".sh" name))
    (builtins.readFile (./scripts + "/${name}")))
  (builtins.attrNames (builtins.readDir ./scripts));
in {
  imports = [
    ./firefox.nix
    ./steam.nix
    ./zeditor.nix
    ./ghostty.nix
    # ./ollama.nix
    # ./boxes.nix
  ];
  environment.systemPackages = scriptPackages ++ shellPackages ++ desktopPackages;
}
