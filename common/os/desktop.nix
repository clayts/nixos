{pkgs, ...}: let
  interface = {
    font-name = "Adwaita Sans 10";
    document-font-name = "Adwaita Sans 10";
    monospace-font-name = "Cascadia Code 10";
    cursor-theme = "Bibata-Modern-Classic";
    gtk-theme = "adw-gtk3";
    gtk-enable-primary-paste = false; # Disable middle-click paste as it can accidentally paste stuff when scrolling
    enable-hot-corners = false;
    font-antialiasing = "greyscale";
    font-hinting = "full";
  };
in {
  environment.systemPackages = with pkgs; [
    # Fonts
    noto-fonts
    adwaita-fonts
    cascadia-code
    noto-fonts-color-emoji

    nautilus
    nautilus-python
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
      gnome-remote-desktop.enable = true;
    };
  };

  # Load regular extensions
  environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "/run/current-system/sw/lib/nautilus/extensions-4";

  # Load Python extensions via the nautilus-python extension
  environment.pathsToLink = ["/share/nautilus-python/extensions"];

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
      };
    }
  ];
}
