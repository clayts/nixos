{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    zed-editor
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
  ];
}
