{pkgs, ...}: {
  environment.systemPackages = let
    zed-editor-fhs = pkgs.buildFHSUserEnv {
      name = "zed-editor";
      targetPkgs = pkgs:
        with pkgs; [
          openssl
          alejandra
          nixd
          zed-editor
        ];
      runScript = "zeditor";
    };

    zed-editor-desktop-item = pkgs.makeDesktopItem {
      name = "zed";
      desktopName = "Zed";
      exec = "${zed-editor-fhs}/bin/zed-editor %F"; # Use the FHS wrapper
      icon = "${pkgs.zed-editor}/share/icons/hicolor/512x512/apps/zed.png"; # Direct path to the icon
      comment = "High-performance, multiplayer code editor";
      categories = ["Development" "TextEditor"];
      mimeTypes = [
        "text/plain"
        "text/x-markdown"
        "text/x-script.python"
        "text/x-rust"
        "text/javascript"
        "application/json"
        "text/x-c"
        "text/x-c++"
      ];
      terminal = false;
      type = "Application";
      genericName = "Text Editor";
      startupNotify = true;
    };
  in
    with pkgs; [
      zed-editor-fhs
      zed-editor-desktop-item

      # Git
      gitg
      git
      gh
    ];
}
