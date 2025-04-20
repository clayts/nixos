{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "md2pdf" ''
      (echo '<head><meta charset=\"utf-8\" /></head>' && md2html $1 -) | html2pdf - $2
    '')
  ];
}
