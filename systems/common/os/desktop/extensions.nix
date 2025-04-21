{pkgs, ...}: let
  extensions = with pkgs.gnomeExtensions; [
    grand-theft-focus
    appindicator
    alphabetical-app-grid
    just-perfection
  ];
in {
  environment.systemPackages = extensions;

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/shell".disable-user-extensions = false;
      settings."org/gnome/shell".enabled-extensions =
        map (
          extension: extension.extensionUuid
        )
        extensions;
      settings."org/gnome/shell/extensions/just-perfection" = {
        panel = false;
        panel-in-overview = true;
        activities-button = false;
        quick-settings-dark-mode = false;
        quick-settings-night-light = false;
        quick-settings-airplane-mode = false;
        window-preview-caption = false;
        background-menu = false;
      };
    }
  ];
}
