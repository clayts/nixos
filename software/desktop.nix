{pkgs, ...}: {
  environment.systemPackages = with pkgs; let
    zed = pkgs.symlinkJoin {
      name = "zed";
      paths = with pkgs; [nodejs zed-editor];
    };
  in [
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
    zed
  ];
}
