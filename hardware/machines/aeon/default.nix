{...}: {
  imports = [
    ./scan.nix
    ../../firmware-updates.nix
    ../../intel.nix
    ../../network.nix
    ../../printer.nix
    ../../sound.nix
    ../../ssd.nix
    ../../fingerprint-reader.nix
    ../../meteor-lake-camera.nix
    ../../iio-sensors.nix
  ];
  # boot.blacklistedKernelModules = ["intel_ipu6_psys" "intel_ipu6_isys"];
}
