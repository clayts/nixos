{pkgs, ...}: let
  extensions = with pkgs.gnomeExtensions; [
    grand-theft-focus
    appindicator
    alphabetical-app-grid
  ];
in {
  environment.systemPackages = extensions;

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/shell".enabled-extensions =
        map (
          extension: extension.extensionUuid
        )
        extensions;
    }
  ];
}
