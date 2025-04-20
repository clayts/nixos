{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "nixos-clean" ''
      nh clean all -k 3 && nix-store --optimise
    '')
  ];
}
