{pkgs, ...}: {
  # hardware.firmware = let
  #   linux-firmware-c1a77 = pkgs.linux-firmware.overrideAttrs (oldAttrs: {
  #     src = pkgs.fetchgit {
  #       url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
  #       rev = "c1a774f36657e30e28a83002a8ebf5add44e02aa";
  #       sha256 = "sha256-aQdEl9+7zbNqWSII9hjRuPePvSfWVql5u5TIrGsa+Ao=";
  #     };
  #   });
  # in [linux-firmware-c1a77];

  environment.sessionVariables = let
    alsa-ucm-conf-30989 = pkgs.alsa-ucm-conf.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "alsa-project";
        repo = "alsa-ucm-conf";
        rev = "30989bd0c2aa3f9f4b6f5e393397b39678717f45"; # or specific commit/tag
        hash = "sha256-cFYEsavUeD6ZyZ/UqyjZnOcSJuOaSBe6sqEH2wOQddc=";
      };
    });
  in {
    ALSA_CONFIG_UCM2 = "${alsa-ucm-conf-30989}/share/alsa/ucm2";
  };

  environment.etc."libinput/local-overrides.quirks".text = pkgs.lib.mkForce ''
    # The ThinkPad X9 15 Gen 1 Forcepad touchpad is not
    # detected as a pressure pad
    [Lenovo ThinkPad X9 15 Gen 1]
    MatchName=*GXTP5100*
    MatchDMIModalias=dmi:*svnLENOVO:*pvrThinkPadX9-15Gen1*:*
    MatchUdevType=touchpad
    ModelPressurePad=1
  '';
}
