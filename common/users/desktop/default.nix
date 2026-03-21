{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./extensions.nix
    ./firefox.nix
    ./ghostty.nix
    ./google-calendar.nix
    ./zed-editor
    ./earthpaper
    ./templates
  ];
  home.packages = with pkgs; [
    # Fonts
    noto-fonts
    adwaita-fonts
    cascadia-code
    joypixels

    gnome-firmware
    loupe
    file-roller
    gnome-calculator
    resources
    gnome-characters
    gnome-logs
    gnome-clocks
    eyedropper
    celluloid
    gitg
    papers
    impression
    baobab
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = ["Adwaita Sans" "Noto Sans"];
      serif = ["Noto Serif"];
      monospace = ["Cascadia Code" "Noto Mono"];
      emoji = ["JoyPixels"];
    };
  };
  dconf.settings = {
    "org/gnome/shell".favorite-apps = [
      "firefox.desktop"
      "com.mitchellh.ghostty.desktop"
    ];
    # Required for touchpad/keyboard games
    "org/gnome/desktop/peripherals/touchpad".disable-while-typing = false;

    # Silences annoying daily beeps
    "org/gnome/evolution-data-server/calendar".notify-enable-audio = false;

    "org/gnome/settings-daemon/plugins/power".power-button-action = "hibernate";
    "org/gnome/desktop/peripherals/touchpad".speed = 0.1;
    "org/gnome/desktop/peripherals/touchpad".tap-to-click = false;
    "org/gnome/nautilus/icon-view".default-zoom-level = "small-plus";
    "org/gnome/desktop/background".picture-uri = ".earthpaper/image.jpeg";

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
      switch-applications = ["<Alt>Tab"];
      switch-applications-backward = ["<Shift><Alt>Tab"];
    };
    "org/gnome/desktop/app-folders" = {
      folder-children = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
    };
  };
}
