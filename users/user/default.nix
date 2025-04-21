{pkgs, ...}: {
  home.stateVersion = "25.05";

  imports = [
    ../modules/default
    {imports = with builtins; map (f: ./scripts + "/${f}") (attrNames (readDir ./scripts));}
    {home.file.".Templates".source = ./templates;}
  ];

  home.packages = with pkgs; [
    # Desktop
    gnome-firmware
    steam

    # Shell
    pciutils
    lshw
  ];
}
