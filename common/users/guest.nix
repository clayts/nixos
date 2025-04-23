{...}: let
  user = "guest";
in {
  users.users.${user} = {
    description = "Guest";
    extraGroups = [];
    isNormalUser = true;
  };

  home-manager.users.${user} = {
    imports = [
      ./desktop
    ];
  };
}
