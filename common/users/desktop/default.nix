{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./extensions.nix
    ./firefox.nix
    ./ghostty.nix
    ./google-calendar.nix
    ./zed-editor
    ./earthpaper
    ./templates
  ];
  home.packages = with pkgs; [
    gnome-firmware
    loupe
    file-roller
    gnome-calculator
    gnome-system-monitor
    gnome-characters
    gnome-logs
    gnome-clocks
    eyedropper
    nautilus
    celluloid
    gitg
    papers
  ];
  dconf.settings = {
    "org/gnome/shell".favorite-apps = [
      "firefox.desktop"
      "org.gnome.Nautilus.desktop"
    ];
    "org/gnome/desktop/peripherals/touchpad".disable-while-typing = false; # Required for touchpad/keyboard games
    "org/gnome/desktop/peripherals/touchpad".speed = 0.1;
    "org/gnome/desktop/peripherals/touchpad".tap-to-click = false;
    "org/gnome/nautilus/icon-view".default-zoom-level = "small-plus";
    "org/gnome/desktop/background".picture-uri = ".earthpaper/image.jpeg";
    "org/gnome/evolution-data-server/calendar".notify-enable-audio = false; # Silences annoying daily beeps
    "org/gnome/settings-daemon/plugins/power".power-button-action = "hibernate";
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
  };
}
