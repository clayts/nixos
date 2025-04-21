{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "colorizer"
      "colored-zed-icons-theme"
    ];
    package = pkgs.symlinkJoin {
      name = "zed-editor-with-langservers";
      paths = with pkgs; [
        zed-editor
        tailwindcss-language-server
        package-version-server
        nixd
        alejandra
      ];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/zeditor \
          --prefix PATH : "${pkgs.vscode-langservers-extracted}/lib/node_modules/vscode-langservers-extracted/bin"
      '';
    };
    userSettings = {
      "hard_tabs" = true;
      "git_panel" = {
        "dock" = "right";
      };
      "icon_theme" = "Colored Zed Icons Theme Dark";
      "show_edit_predictions" = false;
      "assistant" = {
        "default_model" = {
          "provider" = "zed.dev";
          "model" = "claude-3-5-sonnet-latest";
        };
        "dock" = "left";
        "version" = "2";
      };

      "chat_panel" = {
        "dock" = "right";
      };
      "notification_panel" = {
        "dock" = "left";
        "button" = false;
      };
      "features" = {
        "edit_prediction_provider" = "zed";
      };
      "terminal" = {
        #"button": false,
        "dock" = "bottom";
        "env" = {
          "TERM" = "xterm-256color";
        };
        "line_height" = {
          "custom" = 1.15;
        };
      };
      "outline_panel" = {
        "dock" = "right";
        "button" = false;
      };
      "project_panel" = {
        "dock" = "right";
      };
      "collaboration_panel" = {
        "dock" = "right";
        "button" = false;
      };
      "buffer_font_family" = "Cascadia Code";
      "buffer_font_features" = {
        "calt" = true;
        "ss01" = true;
      };
      "buffer_font_weight" = 400;
      "buffer_font_size" = 13;
      "buffer_line_height" = {
        "custom" = 1.15;
      };

      "ui_font_family" = ".SystemUIFont";
      "ui_font_size" = 15;
      "ui_font_weight" = 300;
      "restore_on_startup" = "none";
      "soft_wrap" = "bounded";
      "preferred_line_length" = 100;

      "tabs"."file_icons" = true;

      "theme" = {
        "mode" = "dark";
        "light" = "One Light";
        "dark" = "Colorizer";
      };
      "experimental.theme_overrides" = {
        "syntax" = {
          "comment" = {
            "font_style" = "italic";
          };
          "variable.parameter" = {"font_style" = "normal";};
        };
        "players" = [
          {
            "cursor" = "#F00";
          }
        ];
      };

      "languages" = {
        "Nix" = {
          "language_servers" = ["nixd" "!nil"];
        };
      };

      "node" = {
        "path" = "${pkgs.nodejs}/bin/node";
      };

      "lsp" = {
        "nixd" = {
          "settings" = {"formatting" = {"command" = ["alejandra"];};};
        };
        "rust-analyzer" = {
          "initialization_options" = {
            "checkOnSave" = {
              "command" = "clippy";
            };
          };
        };
      };
    };
  };
}
