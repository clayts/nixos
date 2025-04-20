{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "nixos-switch" ''
      nh os switch /etc/nixos
    '')
  ];
}
