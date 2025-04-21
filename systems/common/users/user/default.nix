{pkgs, ...}: let
  username = "user";
in {
  users.users.${username} = {
    description = "User";
    extraGroups = ["networkmanager" "wheel" "docker"];
    isNormalUser = true;
  };
  home-manager.users.${username} = {
    home.stateVersion = "25.05";

    imports = [
      {imports = with builtins; map (f: ./scripts + "/${f}") (attrNames (readDir ./scripts));}
      {home.file.".Templates".source = ./templates;}
      ../common/firefox.nix
      ../common/ghostty.nix
      ../common/lsd.nix
      ../common/micro.nix
      ../common/other.nix
      ../common/zed-editor.nix
    ];

    home.packages = with pkgs; [
      # Desktop
      gnome-firmware
      steam

      # Shell
      pciutils
      lshw
    ];
  };
}
