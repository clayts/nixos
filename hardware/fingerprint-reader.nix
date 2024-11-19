{...}: {
  services.fprintd.enable = true;

  # GDM should not allow fingerprint authentication for login as it breaks the keyring.
  # In addition, fingerprint authentication seems to be slow and buggy without these hacks,
  # Or not function with GDM at all.
  # Most of these options don't seem to work as expected individually, but in combination
  # produce an adequate result.
  programs.dconf = {
    enable = true;
    profiles.gdm.databases = [
      {
        settings = {
          "org/gnome/login-screen".enable-fingerprint-authentication = false;
        };
      }
    ];
  };
  security.pam.services = {
    gdm-fingerprint.fprintAuth = true;
    login.fprintAuth = false;
  };
}
