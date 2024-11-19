{...}: {
  imports = [
    ./hardware-scan.nix
    ../../hardware/standard
    ../../hardware/fingerprint-reader.nix

    ../../os
    ../../desktop
    ../../apps
  ];
}
