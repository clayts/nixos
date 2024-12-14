{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # GNOME
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

    # Shell
    fzf
    lsd
    fd
    zoxide
    lnav
    stow
    pciutils
    lshw
  ];
}
