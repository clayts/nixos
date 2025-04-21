{pkgs, ...}: {
  # ARC graphics
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-compute-runtime
      vpl-gpu-rt
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965
      intel-ocl
      libvdpau-va-gl
    ];
  };
  hardware.graphics.extraPackages32 = with pkgs.driversi686Linux; [
    intel-vaapi-driver
    intel-media-driver
  ];
}
