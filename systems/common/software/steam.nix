# This module only enables individual users to install steam, it does not install steam itself.
{pkgs, ...}: {
  # Steam
  programs.steam = {
    enable = true;
    package = pkgs.steam-fhsenv-without-steam;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
