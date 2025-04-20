{pkgs, ...}: let
  desktopPackages = with pkgs; [
    loupe
    file-roller
    gnome-calculator
    gnome-system-monitor
    gnome-characters
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
in {
  imports = [
    ./scripts
    ./firefox.nix
    ./steam.nix
    ./zeditor.nix
    ./ghostty.nix
    ./google-calendar.nix
    # ./ollama.nix
    # ./boxes.nix
  ];
  environment.systemPackages = shellPackages ++ desktopPackages;
}
