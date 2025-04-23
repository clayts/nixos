{...}: let
  user = "root";
in {
  home-manager.users.${user} = {
    imports = [
      ./console
    ];
  };
}
