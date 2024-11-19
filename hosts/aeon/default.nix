{pkgs, ...}: {
  imports = [
    ./hardware-scan.nix
    ../../hardware/standard
    ../../hardware/fingerprint-reader.nix
    ../../hardware/meteor-lake-camera.nix
    ../../hardware/iio-sensors.nix

    ../../os
    ../../desktop
    ../../apps
  ];
}
