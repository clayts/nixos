{...}: let
  username = "guest";
  description = "Guest";
  extraGroups = [];
in {
  users.users.${username} = {
    inherit description extraGroups;
    isNormalUser = true;
  };
  home-manager.users.${username} = ./home;
}
