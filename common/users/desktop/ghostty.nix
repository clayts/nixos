{
  config,
  pkgs,
  ...
}: {
  # This allows gnome to use ghostty as a default terminal when running .desktop files that require a terminal
  home.packages = [
    (pkgs.writeShellScriptBin "xterm" ''
      ${pkgs.ghostty} $*
    '')
  ];
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      keybind = [
        "ctrl+c=copy_to_clipboard"
        "ctrl+v=paste_from_clipboard"
        ''ctrl+k=text:\x03''
      ];
      # ghostty +list-fonts
      # font-family = "IBM Plex Mono"
      font-family = "${(builtins.elemAt config.fonts.fontconfig.defaultFonts.monospace 0)}";
      font-size = 10;
      adjust-cell-height = -2;

      # ghostty +list-themes
      # theme = "Dark Modern"
      # theme = "C64"
      theme = "Adwaita Dark";
      # theme = "IR_Black";
      background = "#000000";

      command = "SHLVL=0; zsh";

      # window-theme = "dark";
      window-theme = "ghostty";
      adw-toolbar-style = "raised";
      window-padding-x = 11;
      window-padding-y = 3;
      confirm-close-surface = false;

      window-width = 80;
      window-height = 32;
    };
  };
}
