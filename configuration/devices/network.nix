{hostname, ...}: {
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  networking.hostName = "${hostname}";

  # Workaround for issues getting ipv4 address on certain wireless networks
  # networking.networkmanager.dhcp = "dhcpcd";
  # environment.etc."dhcpcd.conf".text = "";

  # Workaround for issues keeping an ipv4 address on certain wireless networks
  # Seems to cause its own issues
  # networking.networkmanager.wifi.backend = "iwd";
}
