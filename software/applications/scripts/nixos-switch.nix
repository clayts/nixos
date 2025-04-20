{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nixos-switch" ''
      nh os switch /etc/nixos
    '')
  ];
}
