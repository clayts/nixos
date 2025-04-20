{...}: let
  user = username: description: groups: home: {
    users.users.${username} = {
      inherit description;
      isNormalUser = true;
      extraGroups = groups;
    };
    home-manager.users.${username} = home;
  };
in {
  imports = [
    (user "user" "User" ["networkmanager" "wheel" "docker"] ./user)
    (user "guest" "Guest" [] ./guest)
  ];
}
