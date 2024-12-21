{...}: {
  imports = [
    ./hardware.nix

    ../../software

    ../../software/devices/firmware-updates.nix
    ../../software/devices/intel.nix
    ../../software/devices/network.nix
    ../../software/devices/printer.nix
    ../../software/devices/sound.nix
    ../../software/devices/ssd.nix
    ../../software/devices/fingerprint-reader.nix
    ../../software/devices/iio-sensors.nix
    # ../../software/devices/meteor-lake-camera.nix
  ];
}
