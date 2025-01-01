{...}: {
  imports = [
    ./hardware.nix

    ../../software

    ../../configuration
    ../../configuration/devices/firmware-updates.nix
    ../../configuration/devices/intel.nix
    ../../configuration/devices/network.nix
    ../../configuration/devices/printer.nix
    ../../configuration/devices/sound.nix
    ../../configuration/devices/ssd.nix
    ../../configuration/devices/fingerprint-reader.nix
    ../../configuration/devices/iio-sensors.nix
    # ../../configuration/devices/meteor-lake-camera.nix
  ];
}
