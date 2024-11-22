{...}: {
  imports = [
    ./scan.nix
    ../../software/devices/standard
    ../../software/devices/fingerprint-reader.nix

    ../../software/os
    ../../software/desktop
    ../../software/apps
  ];
}
