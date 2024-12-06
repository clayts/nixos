{pkgs, ...}: {
  environment.systemPackages = let
    zed-editor-desktop-item = pkgs.makeDesktopItem {
      name = "dev.zed.Zed";
      desktopName = "Zed";
      exec = "${zed-editor-fhs}/bin/zed-editor %F"; # Use the FHS wrapper
      icon = "${pkgs.zed-editor}/share/icons/hicolor/512x512/apps/zed.png"; # Direct path to the icon
      comment = "High-performance, multiplayer code editor";
      categories = ["Development" "TextEditor"];
      mimeTypes = [
        # Plain Text
        "text/plain"

        # Markup Languages
        "text/x-markdown"
        "text/html"
        "text/xml"
        "application/xml"
        "text/yaml"
        "application/yaml"
        "text/x-rst" # ReStructuredText
        "text/asciidoc"
        "text/x-latex"

        # Web Technologies
        "text/javascript"
        "application/javascript"
        "text/typescript"
        "text/css"
        "application/json"
        "application/ld+json"

        # Systems Programming
        "text/x-c"
        "text/x-c++"
        "text/x-java"
        "text/x-rust"
        "text/x-go"
        "text/x-kotlin"
        "text/x-swift"

        # Scripting Languages
        "text/x-script.python"
        "text/x-ruby"
        "text/x-perl"
        "text/x-php"
        "text/x-lua"
        "text/x-tcl"
        "text/x-shell"
        "text/x-bash"

        # Functional Languages
        "text/x-haskell"
        "text/x-scala"
        "text/x-erlang"
        "text/x-ocaml"
        "text/x-lisp"
        "text/x-scheme"
        "text/x-clojure"

        # Database
        "text/x-sql"
        "application/sql"

        # Configuration
        "text/x-properties"
        "text/x-ini"
        "text/x-toml"

        # Other Languages
        "text/x-pascal"
        "text/x-fortran"
        "text/x-matlab"
        "text/x-r"
        "text/x-julia"
        "text/x-dart"
        "text/x-groovy"
        "text/x-powershell"

        # Assembly
        "text/x-asm"
        "text/x-nasm"

        # Template Languages
        "text/x-handlebars"
        "text/x-mustache"
        "text/x-velocity"
        "text/x-jinja2"
      ];
      terminal = false;
      type = "Application";
      genericName = "Text Editor";
      startupNotify = false;
    };
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
  in
    with pkgs; [
      zed-editor-fhs
      zed-editor-desktop-item

      # HTML
      python312Packages.weasyprint

      # Git
      gitg
      git
      gh
    ];
}
