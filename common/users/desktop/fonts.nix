{pkgs, ...}: {
  home.packages = with pkgs; [
    noto-fonts
    adwaita-fonts
    cascadia-code
    noto-fonts-color-emoji
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = ["Adwaita Sans" "Noto Sans"];
      serif = ["Noto Serif"];
      monospace = ["Cascadia Code" "Noto Mono"];
      emoji = ["Noto Fonts Color Emoji"];
    };
  };
}
