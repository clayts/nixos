{...}: let
  username = "guest";
in {
  users.users.${username} = {
    description = "Guest";
    extraGroups = [];
    isNormalUser = true;
  };
  home-manager.users.${username} = {
    home.stateVersion = "25.05";

    imports = [
      ../common/desktop.nix
      ../common/firefox.nix
      ../common/ghostty.nix
      ../common/lsd.nix
      ../common/micro.nix
      ../common/other.nix
      ../common/zed-editor.nix
    ];
  };
}
