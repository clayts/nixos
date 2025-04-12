{pkgs, ...}: {
  environment.systemPackages =
    map (name:
      pkgs.writeScriptBin
      (builtins.baseNameOf (pkgs.lib.removeSuffix ".sh" name))
      (builtins.readFile (./scripts + "/${name}")))
    (builtins.attrNames (builtins.readDir ./scripts))
    ++ [
      (pkgs.writeScriptBin "html2pdf" "${pkgs.python313Packages.weasyprint}/bin/weasyprint $1 $2")
      (pkgs.writeScriptBin "md2html" "${pkgs.pandoc}/bin/pandoc $1 -o $2")
      (pkgs.writeScriptBin "md2pdf" "(echo '<head><meta charset=\"utf-8\" /></head>' && md2html $1 -) | html2pdf - $2")
    ];
}
