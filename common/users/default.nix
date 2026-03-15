{
  inputs,
  specialArgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./root.nix
    ./user.nix
    ./guest.nix
  ];
  environment.localBinInPath = true;
  environment.variables = {
    XDG_CONFIG_HOME = "$HOME/.config";
  };
  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=.Desktop
    DOWNLOAD=Downloads
    TEMPLATES=.Templates
    PUBLICSHARE=.Public
    DOCUMENTS=Documents
    MUSIC=Music
    PICTURES=Pictures
    VIDEOS=Videos
  '';
  home-manager.sharedModules = [
    {home.stateVersion = "25.05";}
  ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = specialArgs;
    backupFileExtension = "home-manager-backup";
  };
}
