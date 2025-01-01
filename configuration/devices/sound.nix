{...}: {
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
