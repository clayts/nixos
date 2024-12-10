{pkgs, ...}: {
  # Packages
  environment.systemPackages = with pkgs; [
    gnome-console
    loupe
    file-roller
    gnome-calculator
    gnome-system-monitor
    gnome-characters
    gnome-calendar
    nautilus
    celluloid
    gnome-firmware
  ];
}
