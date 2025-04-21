{pkgs, ...}: {
  # Steam
  programs.steam = {
    enable = true;
    package = pkgs.steam-fhsenv-without-steam;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
