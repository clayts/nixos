{...}: {
  imports = [
    ./hardware-scan.nix
    ../../hardware/standard
    ../../hardware/fingerprint-reader.nix
    ../../hardware/meteor-lake-camera.nix

    ../../os
    ../../desktop
    ../../apps
  ];
}
