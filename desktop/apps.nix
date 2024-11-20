{pkgs, ...}: {
  # Packages
  environment.systemPackages = with pkgs; [
    gnome-console
    cheese
    loupe
    file-roller
    gnome-calculator
    gnome-system-monitor
    gnome-characters
    gnome-screenshot
    gnome-calendar
    nautilus
    celluloid
    gnome-text-editor
    gnome-firmware
  ];
}
