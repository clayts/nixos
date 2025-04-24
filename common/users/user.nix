{...}: let
  user = "user";
in {
  users.users.${user} = {
    description = "User";
    extraGroups = [
      "wheel" # gives access to sudo
      "libvirtd" # gives access to boxes
      "networkmanager" # allows setting networks system-wide
    ];
    isNormalUser = true;
  };

  home-manager.users.${user} = {
    imports = [
      ./console
      ./desktop
    ];
  };
}
