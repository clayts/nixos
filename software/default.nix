{pkgs, ...}: let
  desktopPackages = with pkgs; [
    loupe
    file-roller
    gnome-calculator
    gnome-system-monitor
    gnome-characters

    gnome-calendar
    # # Allow using Google as calendar
    # (pkgs.makeDesktopItem {
    #   name = "com.google.Calendar";
    #   desktopName = "Google Calendar";
    #   noDisplay = true;
    #   mimeTypes = ["text/calendar"];
    #   # dbusActivatable = true;
    #   exec = "xdg-open https://www.google.com/calendar";
    # })

    gnome-logs
    eyedropper
    nautilus
    celluloid
    gnome-firmware
    gitg
    apostrophe
    errands
    papers
    libreoffice
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
    ./firefox.nix
    ./steam.nix
    ./zeditor.nix
    ./ghostty.nix
    ./scripts.nix
    # ./iotas.nix
    # ./ollama.nix
    # ./boxes.nix
  ];
  environment.systemPackages = shellPackages ++ desktopPackages;
}
