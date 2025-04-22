{inputs, ...}: {
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      # SearchBar = "unified";
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

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
        extraConfig = builtins.readFile "${inputs.firefox-theme}/configuration/user.js";

        settings = {
          "extensions.pocket.enabled" = false;
          "browser.newtabpage.pinned" = "";
          "browser.topsites.contile.enabled" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.system.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.toolbars.bookmarks.visibility" = "never";
          "media.ffmpeg.vaapi.enabled" = true;

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
