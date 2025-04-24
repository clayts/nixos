{pkgs, ...}: let
  extensions = with pkgs.gnomeExtensions; [
    grand-theft-focus
    appindicator
    alphabetical-app-grid
    just-perfection
  ];
in {
  programs.gnome-shell = {
    enable = true;
    extensions = map (extension: {package = extension;}) extensions;
  };

  dconf.settings = {
    "org/gnome/shell".disable-user-extensions = false;
    "org/gnome/shell".enabled-extensions =
      map (extension: extension.extensionUuid)
      extensions;
    "org/gnome/shell/extensions/just-perfection" = {
      panel = false;
      panel-in-overview = true;
      activities-button = false;
      quick-settings-dark-mode = false;
      quick-settings-night-light = false;
      quick-settings-airplane-mode = false;
      window-preview-caption = false;
      background-menu = false;
      support-notifier-showed-version = pkgs.gnomeExtensions.just-perfection.version;
      support-notifier-type = 0;
    };
  };
}
