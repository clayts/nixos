{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "html2pdf" ''
      ${pkgs.python313Packages.weasyprint}/bin/weasyprint $1 $2
    '')
  ];
}
