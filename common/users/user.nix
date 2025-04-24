{...}: let
  user = "user";
in {
  users.users.${user} = {
    description = "User";
    extraGroups = ["wheel" "libvirtd"];
    isNormalUser = true;
  };

  home-manager.users.${user} = {
    imports = [
      ./console
      ./desktop
    ];
  };
}
