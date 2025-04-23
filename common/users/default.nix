{...}: {
  imports = [
    ./root.nix
    ./user.nix
    ./guest.nix
  ];

  home-manager.sharedModules = [
    {
      home.stateVersion = "25.05";
    }
  ];
}
