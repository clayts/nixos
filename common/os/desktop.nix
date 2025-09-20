{
  pkgs,
  config,
  lib,
  ...
}: let
  interface = {
    font-name = "${(builtins.elemAt config.fonts.fontconfig.defaultFonts.sansSerif 0) + " 10"}";
    document-font-name = "${(builtins.elemAt config.fonts.fontconfig.defaultFonts.serif 0) + " 10"}";
    monospace-font-name = "${(builtins.elemAt config.fonts.fontconfig.defaultFonts.monospace 0) + " 10"}";
    cursor-theme = "Bibata-Modern-Classic";
    gtk-theme = "adw-gtk3";
    gtk-enable-primary-paste = false; # Disable middle-click paste as it can accidentally paste stuff when scrolling
    enable-hot-corners = false;
    font-antialiasing = "greyscale";
    font-hinting = "full";
  };
in {
  # Packages
  environment.systemPackages = with pkgs; [
    yelp

    # Hide CUPS
    (pkgs.makeDesktopItem {
      name = "cups";
      desktopName = "";
      noDisplay = true;
    })

    # Theme
    bibata-cursors
    adw-gtk3
  ];

  # GNOME
  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    gnome = {
      core-apps.enable = false;
      gnome-online-accounts.enable = true;
    };
  };

  # Remove bloat
  services.xserver.excludePackages = with pkgs; [xterm];
  environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-screenshot];

  # Fixes various fingerprint bugs and issues
  security.pam.services = {
    gdm-fingerprint.fprintAuth = true;
    login.fprintAuth = false;
  };

  # Dconf
  programs.dconf.enable = true;

  programs.dconf.profiles.gdm.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = interface;

        # Fixes various fingerprint bugs and issues
        "org/gnome/login-screen".enable-fingerprint-authentication = false;
      };
    }
  ];

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = interface;
        "org/gnome/desktop/app-folders" = {folder-children = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);};
      };
    }
  ];
}
