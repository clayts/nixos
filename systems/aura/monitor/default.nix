{...}: {
  home-manager.sharedModules = [
    {
      home.file.".config/monitors.xml".source = ./monitors.xml;
    }
  ];
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${./monitors.xml}"
  ];
}
