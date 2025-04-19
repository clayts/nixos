{
  pkgs,
  config,
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
  imports = [
    ./extensions.nix
    ./fonts.nix
    ./wallpaper.nix
  ];

  # Packages
  environment.systemPackages = with pkgs; [
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
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
    gnome = {
      core-utilities.enable = false;
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
        "org/gnome/desktop/app-folders" = {folder-children = ["Games" "LibreOffice" "System"];};
        "org/gnome/desktop/app-folders/folders/System" = {
          name = "System";
          categories = ["System"];
          apps = ["org.gnome.Extensions.desktop" "org.gnome.Firmware.desktop" "org.gnome.Settings.desktop"];
        };
        "org/gnome/desktop/app-folders/folders/Games" = {
          name = "Games";
          categories = ["Game"];
        };
        "org/gnome/desktop/app-folders/folders/LibreOffice" = {
          name = "LibreOffice";
          apps = ["startcenter.desktop" "base.desktop" "calc.desktop" "draw.desktop" "impress.desktop" "math.desktop" "writer.desktop"];
        };
        "org/gnome/shell".favorite-apps = [
          "firefox.desktop"
          "org.gnome.Nautilus.desktop"
        ];
        "org/gnome/desktop/peripherals/touchpad".disable-while-typing = false; # Required for touchpad/keyboard games
        "org/gnome/desktop/peripherals/touchpad".speed = 0.1;
        "org/gnome/desktop/peripherals/touchpad".tap-to-click = false;
        "org/gnome/nautilus/icon-view".default-zoom-level = "small-plus";
        "org/gnome/desktop/interface" = interface;
        "org/gnome/desktop/background".picture-uri = "/tmp/wallpaper.jpg";
        "org/gnome/evolution-data-server/calendar".notify-enable-audio = false; # Silences annoying daily beeps
        # "org/gnome/gitlab/cheywood/Iotas".editor-header-bar-visibility = "auto-hide";
        # "org/gnome/gitlab/cheywood/Iotas".editor-theme = "iotas-alpha-bold";

        "org/gnome/mutter" = {
          dynamic-workspaces = true;
          edge-tiling = true;
          workspaces-only-on-primary = true;
          center-new-windows = true;
        };
        "org/gnome/settings-daemon/plugins/media-keys".play = ["Favorites"];
        "org/gnome/desktop/wm/keybindings" = {
          toggle-fullscreen = ["<Super>f"];
          close = ["<Super>q"];
          switch-windows = ["<Super>Tab"];
          switch-windows-backward = ["<Shift><Super>Tab"];
          switch-applications = ["<Alt>Tab"];
          switch-applications-backward = ["<Shift><Alt>Tab"];
        };
      };
    }
  ];
}
