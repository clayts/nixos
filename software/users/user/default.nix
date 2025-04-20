{...}: let
  username = "user";
  description = "User";
  extraGroups = ["networkmanager" "wheel" "docker"];
in {
  users.users.${username} = {
    inherit description extraGroups;
    isNormalUser = true;
  };
  home-manager.users.${username} = ./home;
}
