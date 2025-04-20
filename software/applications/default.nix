{pkgs, ...}: {
  imports = [
    ./scripts
    ./firefox.nix
    ./steam.nix
    ./google-calendar.nix
    # ./zeditor.nix
    # ./ghostty.nix
    # ./ollama.nix
    # ./boxes.nix
  ];
  environment.systemPackages = with pkgs; [
    # Desktop
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

    # Shell
    fzf
    lsd
    fd
    zoxide
    pciutils
    lshw
    git
    gh
  ];
}
