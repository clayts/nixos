{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    extensions = [
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
    themes = {custom = ./theme.json;};
    userSettings = {
      assistant = {
        default_model = {
          model = "deepseek/deepseek-chat-v3-0324:free";
          provider = "openai";
          # model = "claude-3-5-sonnet-latest";
          # provider = "zed.dev";
        };
        dock = "left";
        version = "2";
      };
      language_models = {
        openai = {
          version = "1";
          api_url = "https://openrouter.ai/api/v1";
          "available_models" = [
            {
              display_name = "DeepSeek V3 0324 (free)";
              name = "deepseek/deepseek-chat-v3-0324:free";
              max_tokens = 163840;
            }
            {
              display_name = "DeepSeek: R1 (free)";
              name = "deepseek/deepseek-r1:free";
              max_tokens = 163840;
            }
            {
              display_name = "Google: Gemini 2.0 Flash Experimental (free)";
              name = "google/gemini-2.0-flash-exp:free";
              max_tokens = 1048576;
            }
            {
              display_name = "Anthropic: Claude 3.7 Sonnet (thinking)";
              name = "anthropic/claude-3.7-sonnet:thinking";
              max_tokens = 200000;
            }
            {
              display_name = "Anthropic: Claude 3.7 Sonnet";
              name = "anthropic/claude-3.7-sonnet";
              max_tokens = 200000;
            }
            {
              display_name = "Anthropic: Claude 3.5 Haiku";
              name = "anthropic/claude-3.5-haiku";
              max_tokens = 200000;
            }
          ];
        };
      };
      hard_tabs = true;
      git_panel = {
        dock = "right";
      };
      icon_theme = "Colored Zed Icons Theme Dark";
      show_edit_predictions = false;

      project_panel = {indent_guides = {show = "never";};};
      indent_guides = {
        enabled = false;
      };
      chat_panel = {
        dock = "right";
      };
      notification_panel = {
        dock = "left";
        button = false;
      };
      disable_ai = true;
      diagnostics = {
        inline = {
          enabled = true;
        };
      };
      features = {
        edit_prediction_provider = "zed";
      };
      terminal = {
        # button : false,
        dock = "bottom";
        env = {
          TERM = "xterm-256color";
        };
        line_height = {
          custom = 1.15;
        };
      };
      outline_panel = {
        dock = "right";
        button = false;
      };
      project_panel = {
        dock = "right";
      };
      collaboration_panel = {
        dock = "right";
        button = false;
      };
      buffer_font_family = "Cascadia Code";
      buffer_font_features = {
        calt = true;
        ss01 = true;
      };
      buffer_font_weight = 400;
      buffer_font_size = 13;
      buffer_line_height = {
        custom = 1.15;
      };

      ui_font_family = ".SystemUIFont";
      ui_font_size = 16;
      ui_font_weight = 300;
      restore_on_startup = "none";
      soft_wrap = "bounded";
      preferred_line_length = 100;

      tabs.file_icons = true;

      theme = {
        mode = "dark";
        light = "One Light";
        dark = "Custom";
      };

      languages = {
        Nix = {
          language_servers = ["nixd" "!nil"];
        };
        # XML = {
        #   prettier = {
        #     allowed = true;
        #     plugins = ["@prettier/plugin-xml"];
        #     path = "${pkgs.nodePackages.prettier}/bin/prettier";
        #   };
        # };
      };

      node = {
        path = "${pkgs.nodejs}/bin/node";
      };

      lsp = {
        nixd = {
          settings = {formatting = {command = ["alejandra"];};};
        };
        rust-analyzer = {
          "binary" = {
            # "path" = "rust-analyzer";
            "path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            args = [];
          };
          initialization_options = {
            # checkOnSave = {
            #   command = "clippy";
            # };
            check = {
              command = "clippy";
            };
          };
        };
      };
    };
  };
}
