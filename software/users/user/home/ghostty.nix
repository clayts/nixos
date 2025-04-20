{...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # ghostty +list-fonts
      # font-family = "IBM Plex Mono"
      font-family = "Cascadia Code";
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
