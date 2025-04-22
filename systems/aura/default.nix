{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ../common/hardware/arc.nix
    ./monitor

    ../common/os
    ../common/users
    ../common/software/steam.nix
  ];

  services.fprintd.enable = true;
  hardware.sensor.iio.enable = true;
  services.thermald.enable = true;
  services.fstrim.enable = true;

  # Prevent bluetooth from automatically starting on boot
  hardware.bluetooth.powerOnBoot = false;

  # Hacks
  ## Sound
  environment.sessionVariables = let
    alsa-ucm-conf-git = pkgs.alsa-ucm-conf.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "alsa-project";
        repo = "alsa-ucm-conf";
        rev = "30989bd0c2aa3f9f4b6f5e393397b39678717f45";
        hash = "sha256-cFYEsavUeD6ZyZ/UqyjZnOcSJuOaSBe6sqEH2wOQddc=";
      };
    });
  in {
    ALSA_CONFIG_UCM2 = "${alsa-ucm-conf-git}/share/alsa/ucm2";
  };

  ## Touchpad
  environment.etc."libinput/local-overrides.quirks".text = ''
    # The ThinkPad X9 15 Gen 1 Forcepad touchpad is not
    # detected as a pressure pad
    [Lenovo ThinkPad X9 15 Gen 1]
    MatchName=*GXTP5100*
    MatchDMIModalias=dmi:*svnLENOVO:*pvrThinkPadX9-15Gen1*:*
    MatchUdevType=touchpad
    ModelPressurePad=1
  '';
}
