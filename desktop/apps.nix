{pkgs, ...}: {
  # Packages
  environment.systemPackages = with pkgs; [
    gnome-console
    cheese
    loupe
    file-roller
    gnome-calculator
    gnome-system-monitor
    gnome-characters
    gnome-screenshot
    gnome-calendar
    nautilus
    celluloid
    gnome-text-editor
    gnome-firmware
  ];

  # Firefox
  programs.firefox = let
    lock-false = {
      Value = false;
      Status = "locked";
    };
    lock-true = {
      Value = true;
      Status = "locked";
    };
    lock-empty-string = {
      Value = "";
      Status = "locked";
    };
  in {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      SearchBar = "unified";

      Preferences = {
        "extensions.pocket.enabled" = lock-false;
        "browser.newtabpage.pinned" = lock-empty-string;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = lock-true;
        "browser.toolbars.bookmarks.visibility" = "never";
      };

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
