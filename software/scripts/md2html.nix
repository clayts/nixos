{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "md2html" ''
      ${pkgs.pandoc}/bin/pandoc $1 -o $2
    '')
  ];
}
