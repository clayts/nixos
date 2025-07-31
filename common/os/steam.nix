# This module only enables individual users to install steam, it does not install steam itself.
{...}: {
  # Steam
  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true;
    # dedicatedServer.openFirewall = true;
  };
}
