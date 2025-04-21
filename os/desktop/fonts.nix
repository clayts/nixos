{pkgs, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    adwaita-fonts
    cascadia-code
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = ["Adwaita Sans" "Noto Sans"];
      serif = ["Noto Serif"];
      monospace = ["Cascadia Code" "Noto Mono"];
    };
  };
}
