{pkgs, ...}: let
  extensions = let
    rounded-window-corners-reborn = pkgs.callPackage ./rounded-window-corners-reborn {};
  in
    with pkgs.gnomeExtensions; [
      rounded-window-corners-reborn
      grand-theft-focus
      appindicator
      alphabetical-app-grid
      # hide-top-bar
      # transparent-top-bar-adjustable-transparency
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
