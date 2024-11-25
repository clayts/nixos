{
  pkgs,
  config,
  ...
}: let
  interface = {
    font-name = "${(builtins.elemAt config.fonts.fontconfig.defaultFonts.sansSerif 0) + " " + "11"}";
    document-font-name = "${(builtins.elemAt config.fonts.fontconfig.defaultFonts.serif 0) + " " + "11"}";
    monospace-font-name = "${(builtins.elemAt config.fonts.fontconfig.defaultFonts.monospace 0) + " " + "Semilight 11"}";
    icon-theme = "Papirus";
    cursor-theme = "Bibata-Modern-Classic";
    gtk-theme = "adw-gtk3";
    gtk-enable-primary-paste = false; # Disable middle-click paste as it can accidentally paste stuff when scrolling
    enable-hot-corners = false;
  };
in {
  imports = [
    ./apps.nix
    ./extensions.nix
  ];

  # Packages
  environment.systemPackages = with pkgs; [
    ## Hide CUPS
    (pkgs.makeDesktopItem {
      name = "cups";
      desktopName = "";
      noDisplay = true;
    })

    ## Theme
    bibata-cursors
    papirus-icon-theme
    adw-gtk3

    ## Fonts
    (nerdfonts.override {fonts = ["CascadiaCode"];})
    noto-fonts
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

  # Remote bloat
  services.xserver.excludePackages = with pkgs; [xterm];
  environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-screenshot];

  # Fonts
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = ["Noto Sans"];
      serif = ["Noto Serif"];
      monospace = ["CaskaydiaCove Nerd Font"];
    };
  };

  # Wallpaper
  systemd.timers."wallpaper-switcher" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services."wallpaper-switcher" = {
    script = ''
      echo "Fetching index"
      baseURL="https://raw.githubusercontent.com/clayts/Wallpapers/master"
      indexPath="index.txt"
      index=($(${pkgs.curl}/bin/curl -s "$baseURL/$indexPath"))
      echo "Index contains ''${#index[@]} images"
      path="$(printf "%s\n" "''${index[@]}" | shuf -n1)"
      if [ "$path" = "" ]
      then
          echo "Failed"
          exit 1
      fi
      echo "Fetching $path"
      temp=$(mktemp) && chmod +r $temp &&
      (
          ${pkgs.curl}/bin/curl -s "$baseURL/$path" > $temp &&
          mv $temp /tmp/wallpaper.jpg && echo "Wrote /tmp/wallpaper.jpg"
      ) || (
          rm $temp && echo "Failed" && exit 1
      )
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # Dconf
  programs.dconf.enable = true;
  programs.dconf.profiles.gdm.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = interface;
      };
    }
  ];
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        ## App menu
        ### App folders
        "org/gnome/desktop/app-folders" = {folder-children = ["Games"];};
        "org/gnome/desktop/app-folders/folders/Games" = {
          name = "Games";
          categories = ["Game"];
        };
        "org/gnome/shell".favorite-apps = [
          "firefox.desktop"
          "org.gnome.Nautilus.desktop"
        ];

        "org/gnome/desktop/interface" = interface;
        "org/gnome/desktop/background".picture-uri = "/tmp/wallpaper.jpg";
        "org/gnome/evolution-data-server.calendar" = {
          notify-enable-audio = false; # Silences annoying daily beeps
        };
        "org/gnome/TextEditor" = {
          restore-session =
            false;
        };

        "org/gnome/mutter" = {
          dynamic-workspaces = true;
          edge-tiling = true;
          workspaces-only-on-primary = true;
        };
        "org/gnome/desktop/wm/keybindings" = {
          toggle-fullscreen = ["<Super>f"];
          close = ["<Super>q"];
          switch-windows = ["<Super>Tab"];
          switch-windows-backward = ["<Shift><Super>Tab"];
        };
      };
    }
  ];
}
