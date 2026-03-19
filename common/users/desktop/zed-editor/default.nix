{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "colored-zed-icons-theme"
      "superhtml"
      "nix"
      "color-highlight"
    ];
    package = pkgs.symlinkJoin {
      name = "zed-editor-bundle";
      paths = with pkgs; [
        zed-editor
        color-lsp
        cascadia-code
        adwaita-fonts
      ];
    };
    themes.custom = ./theme.json;
    userSettings = {
      hard_tabs = true;
      git_panel.dock = "right";
      git_panel.status_style = "icon";
      icon_theme = "Colored Zed Icons Theme Dark";
      show_edit_predictions = false;
      project_panel.indent_guides.show = "never";
      project_panel = {
        starts_open = false;
        auto_open = {
          on_create = false;
          on_paste = false;
          on_drop = false;
        };
      };
      indent_guides.enabled = false;
      notification_panel.button = false;
      disable_ai = true;
      diagnostics.inline.enabled = true;
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
      gutter = {
        line_numbers = false;
        runnables = false;
        breakpoints = false;
        folds = false;
      };
      tab_bar = {
        show = false;
        show_nav_history_buttons = true;
        show_tab_bar_buttons = true;
      };
      toolbar = {
        breadcrumbs = true;
        quick_actions = true;
      };
      restore_on_startup = "empty_tab";
      buffer_font_weight = 400;
      buffer_font_size = 13;
      buffer_line_height.custom = 1.15;
      ui_font_family = "Adwaita Sans";
      ui_font_size = 16;
      ui_font_weight = 300;
      soft_wrap = "preferred_line_length";
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
      lsp_document_colors = "background";
      lsp = {
        nixd.settings.formatting.command = ["alejandra"];
        rust-analyzer.initialization_options.check.command = "clippy";
      };
    };
  };
}
