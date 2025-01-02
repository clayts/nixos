{pkgs, ...}: {
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Other
  environment.systemPackages = let
    sabaki = pkgs.makeDesktopItem {
      name = "sabaki";
      desktopName = "Sabaki";
      # icon = "${pkgs.papirus-icon-theme}/share/icons/Papirus/64x64/apps/qgo.svg";
      categories = ["Game"];
      exec = let
        sabaki-appimg = builtins.fetchurl {
          url = "https://github.com/SabakiHQ/Sabaki/releases/download/v0.52.2/sabaki-v0.52.2-linux-x64.AppImage";
          sha256 = "sha256:0inlp5wb8719qygcac5268afim54ds7knffp765csrfdggja7q62";
        };
      in ''sh -c "${(pkgs.appimage-run.override {extraPkgs = pkgs: [pkgs.xorg.libxshmfence];})}/bin/appimage-run ${sabaki-appimg}"'';
    };

    leela-zero-with-weights = let
      leela-zero-weights = builtins.fetchurl {
        url = "https://zero.sjeng.org/best-network";
        sha256 = "sha256:03f0ib2jnkfyaz15h0jqmnhr3i0g7hnibxw6yskw6s5kf04z0dv9";
      };
    in
      pkgs.writeShellScriptBin "leelaz" ''
        exec ${pkgs.leela-zero}/bin/leelaz -w ${leela-zero-weights} $*
      '';
  in
    with pkgs; [
      # Games
      ## Go
      leela-zero-with-weights
      gnugo
      sabaki
    ];
}
