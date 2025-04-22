{pkgs, ...}: {
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

    # Shell
    fd
    git
    gh
  ];
}
