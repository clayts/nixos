{pkgs, ...}: {
  environment.systemPackages = [pkgs.gnome-boxes];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };
}
