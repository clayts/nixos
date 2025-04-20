{
  inputs,
  pkgs,
  ...
}: {
  home.stateVersion = "25.05";

  home.file.".Templates".source = ./templates;

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

  programs.micro = {
    enable = true;
    settings = {
      "colorscheme" = "custom";
      "mkparents" = true;
      "wordwrap" = true;
      "softwrap" = true;
    };
  };
  home.file.".config/micro/colorschemes/custom.micro".text = ''
    color-link default "#F8F8F2"
    color-link comment "#75715E"
    color-link identifier "#66D9EF"
    color-link constant "#AE81FF"
    color-link constant.string "#E6DB74"
    color-link constant.string.char "#BDE6AD"
    color-link statement "#F92672"
    color-link symbol.operator "#F92672"
    color-link preproc "#CB4B16"
    color-link type "#66D9EF"
    color-link special "#A6E22E"
    color-link underlined "#D33682"
    color-link error "bold #CB4B16"
    color-link todo "bold #D33682"
    color-link hlsearch "#282828,#E6DB74"
    color-link statusline "#282828,#F8F8F2"
    color-link tabbar "#282828,#F8F8F2"
    color-link indent-char "#505050"
    color-link line-number "#AAAAAA,#323232"
    color-link current-line-number "#AAAAAA"
    color-link diff-added "#00AF00"
    color-link diff-modified "#FFAF00"
    color-link diff-deleted "#D70000"
    color-link gutter-error "#CB4B16"
    color-link gutter-warning "#E6DB74"
    color-link cursor-line "#323232"
    color-link color-column "#323232"
    #No extended types; Plain brackets.
    color-link type.extended "default"
    #color-link symbol.brackets "default"
    color-link symbol.tag "#AE81FF"
    color-link match-brace "#282828,#AE81FF"
    color-link tab-error "#D75F5F"
    color-link trailingws "#D75F5F"
  '';
  home.file.".config/micro/bindings.json".text = ''
    {
        "Alt-/": "lua:comment.comment",
    }
  '';

  programs.lsd = {
    enable = true;
    icons = {
      filetype = {
        dir = "";
      };
      name = {
        videos = "󱧺";
        desktop = "󱋣";
        documents = "󰲂";
        public = "󱞊";
        home = "󱂵";
      };
    };
  };

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

  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        userChrome = ''
          @import "${inputs.firefox-theme}/userChrome.css";
        '';
        userContent = ''
          @import "${inputs.firefox-theme}/userContent.css";
        '';
        extraConfig = "${inputs.firefox-theme}/configuration/user.js";

        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.cache.disk.enable" = false; # Be kind to hard drive

          "gnomeTheme.hideSingleTab" = true;
          # "browser.tabs.tabmanager.enabled" = true; # TODO: Check this is necessary
          "browser.uiCustomization.state" = {
            "placements" = {
              "widget-overflow-fixed-list" = [];
              "unified-extensions-area" = ["ublock0_raymondhill_net-browser-action"];
              "nav-bar" = ["back-button" "forward-button" "stop-reload-button" "customizableui-special-spring1" "urlbar-container" "new-tab-button" "customizableui-special-spring2" "downloads-button" "unified-extensions-button"];
              # "firefox-view-button"
              "toolbar-menubar" = ["menubar-items"];
              "TabsToolbar" = ["tabbrowser-tabs" "alltabs-button"];
              "vertical-tabs" = [];
              "PersonalToolbar" = ["import-button" "personal-bookmarks"];
            };
            "dirtyAreaCache" = ["nav-bar" "vertical-tabs" "PersonalToolbar" "unified-extensions-area" "widget-overflow-fixed-list" "TabsToolbar" "toolbar-menubar"];
            "currentVersion" = 20;
            "newElementCount" = 4;
          };
          "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.showSearch" = false;
          "browser.newtabpage.activity-stream.topSitesRows" = 3;
          "browser.uidensity" = 0;
          "svg.context-properties.content.enabled" = true;
          "browser.theme.dark-private-windows" = false;
          "widget.gtk.rounded-bottom-corners.enabled" = true;
          "gnomeTheme.normalWidthTabs" = false;
          "gnomeTheme.swapTabClose" = false;
          "gnomeTheme.bookmarksToolbarUnderTabs" = false;
          "gnomeTheme.tabsAsHeaderbar" = false;
          "gnomeTheme.tabAlignLeft" = false;
          "gnomeTheme.activeTabContrast" = false;
          "gnomeTheme.closeOnlySelectedTabs" = true;
          "gnomeTheme.symbolicTabIcons" = false;
          "gnomeTheme.allTabsButton" = false;
          "gnomeTheme.allTabsButtonOnOverflow" = false;
          "gnomeTheme.hideWebrtcIndicator" = false;
          "gnomeTheme.oledBlack" = true;
          "gnomeTheme.noThemedIcons" = false;
          "gnomeTheme.bookmarksOnFullscreen" = false;
        };
      };
    };
  };
}
