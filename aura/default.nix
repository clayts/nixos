{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ./disks.nix

    ../common/os
    ../common/users
  ];

  # Prevent bluetooth from automatically starting on boot
  hardware.bluetooth.powerOnBoot = false;

  # Remap star key to play button
  programs.dconf.profiles.user.databases = [{settings."org/gnome/settings-daemon/plugins/media-keys".play = ["Favorites"];}];

  # Force 120hz
  home-manager.sharedModules = [{home.file.".config/monitors.xml".source = ./monitors.xml;}];
  systemd.tmpfiles.rules = ["L+ /run/gdm/.config/monitors.xml - - - - ${./monitors.xml}"];

  # Enable miscellanious hardware
  services.fprintd.enable = true;
  hardware.sensor.iio.enable = true;
  services.thermald.enable = true;
  services.fstrim.enable = true;

  # ARC graphics
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-compute-runtime
      vpl-gpu-rt
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965
      intel-ocl
      libvdpau-va-gl
    ];
  };
  hardware.graphics.extraPackages32 = with pkgs.driversi686Linux; [
    intel-vaapi-driver
    intel-media-driver
  ];

  # Temporary Hacks
  ## Sound
  environment.sessionVariables = let
    alsa-ucm-conf-git = pkgs.alsa-ucm-conf.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "alsa-project";
        repo = "alsa-ucm-conf";
        rev = "30989bd0c2aa3f9f4b6f5e393397b39678717f45";
        hash = "sha256-cFYEsavUeD6ZyZ/UqyjZnOcSJuOaSBe6sqEH2wOQddc=";
      };
    });
  in {
    ALSA_CONFIG_UCM2 = "${alsa-ucm-conf-git}/share/alsa/ucm2";
  };
}
