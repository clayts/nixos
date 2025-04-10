{...}: {
  imports = [
    ./system.nix
    ./arc.nix
    ./fixes.nix
  ];

  services.fprintd.enable = true;
  hardware.sensor.iio.enable = true;
  services.thermald.enable = true;
  services.fstrim.enable = true;

  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # # Fix sound on Noita
  # services.pipewire.enable = false;
  # services.gnome.gnome-remote-desktop.enable = false;
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;
}
