{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
    ./disks.nix

    ../common/os
    ../common/users
  ];
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
      # intel-ocl
      libvdpau-va-gl
    ];
  };
  hardware.graphics.extraPackages32 = with pkgs.driversi686Linux; [
    intel-vaapi-driver
    intel-media-driver
  ];

  # Workarounds
  # necessary due to audio bug in 6.17.8
  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor (pkgs.linux_6_17.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
        sha256 = "sha256-3fLqDUQ54dVxNr42IxAq+UWPYB9bHLd+gyRuiK6gnQ4=";
      };
      version = "6.17.7";
      modDirVersion = "6.17.7";
    };
  }));
}
