{...}: {
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  ## Workaround for issues connecting to certain wireless access points
  networking.networkmanager.dhcp = "dhcpcd";
  environment.etc."dhcpcd.conf".text = "";
}
