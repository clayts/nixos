{...}: {
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Workaround for issues getting ipv4 address on certain wireless networks
  networking.networkmanager.dhcp = "dhcpcd";
  environment.etc."dhcpcd.conf".text = "";

  # Workaround for issues keeping an ipv4 address on certain wireless networks
  networking.networkmanager.wifi.backend = "iwd";
}
