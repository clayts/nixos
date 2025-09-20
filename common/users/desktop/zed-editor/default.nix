{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "colored-zed-icons-theme"
      "superhtml"
    ];
    package = pkgs.symlinkJoin {
      name = "zed-editor-with-langservers";
      paths = with pkgs; [
        zed-editor
        tailwindcss-language-server
        package-version-server
        vscode-langservers-extracted
      ];
    };
    themes.custom = ./theme.json;
    userSettings = {
      hard_tabs = true;
      git_panel. dock = "right";
      icon_theme = "Colored Zed Icons Theme Dark";
      show_edit_predictions = false;
      project_panel.indent_guides.show = "never";
      indent_guides.enabled = false;
      notification_panel.button = false;
      disable_ai = true;
      diagnostics.inline.enabled = true;
      features.edit_prediction_provider = "zed";
      terminal.button = false;
      debugger.button = false;
      outline_panel.button = false;
      project_panel.dock = "right";
      collaboration_panel.button = false;
      buffer_font_family = "Cascadia Code";
      buffer_font_features = {
        calt = true;
        ss01 = true;
      };
      buffer_font_weight = 400;
      buffer_font_size = 13;
      buffer_line_height.custom = 1.15;
      ui_font_family = ".SystemUIFont";
      ui_font_size = 16;
      ui_font_weight = 300;
      restore_on_startup = "none";
      soft_wrap = "bounded";
      preferred_line_length = 100;
      tabs.file_icons = true;
      theme = {
        mode = "dark";
        light = "Ayu Light";
        dark = "Custom";
      };

      node.path = "${pkgs.nodejs}/bin/node";

      languages = {
        Nix.language_servers = ["nixd"];
        HTML = {
          language_servers = ["superhtml"];
          formatter.language_server.name = "superhtml";
        };
      };

      lsp = {
        nixd.settings.formatting.command = ["alejandra"];
        rust-analyzer.initialization_options.check.command = "clippy";
      };
    };
  };
}
