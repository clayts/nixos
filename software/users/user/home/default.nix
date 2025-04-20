{pkgs, ...}: {
  imports = [
    {home.file.".Templates".source = ./templates;}
    ./scripts
    ./firefox.nix
    ./ghostty.nix
    ./lsd.nix
    ./micro.nix
    ./zed-editor.nix
  ];

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
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
    steam

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
