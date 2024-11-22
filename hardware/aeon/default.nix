{...}: {
  imports = [
    ./scan.nix
    ../../software/devices/standard
    ../../software/devices/fingerprint-reader.nix
    ../../software/devices/meteor-lake-camera.nix
    ../../software/devices/iio-sensors.nix

    ../../software/os
    ../../software/desktop
    ../../software/apps
  ];
}
