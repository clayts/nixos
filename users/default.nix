{...}: {
  imports = [
    (let
      username = "user";
    in {
      users.users.${username} = {
        description = "User";
        extraGroups = ["networkmanager" "wheel" "docker"];
        isNormalUser = true;
      };
      home-manager.users.${username} = ./user;
    })
    (let
      username = "guest";
    in {
      users.users.${username} = {
        description = "Guest";
        extraGroups = [];
        isNormalUser = true;
      };
      home-manager.users.${username} = ./guest;
    })
  ];
}
