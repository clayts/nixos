{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./desktop.nix
    ./console.nix
    ./steam.nix
  ];

  # Version
  system.stateVersion = "24.11";

  # Boot
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    plymouth.enable = true;
    initrd.verbose = false;
    consoleLogLevel = 0;
  };

  # Culture
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  time.timeZone = "Europe/London";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };
  environment.systemPackages = [
    (pkgs.aspellWithDicts (dicts: [
      dicts.en
      dicts.en-computers
      dicts.en-science
    ]))
  ];

  # Suspend
  systemd.sleep.settings.Sleep.HibernateDelaySec = "24h";

  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  # Zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Sudo
  security.sudo = {
    wheelNeedsPassword = false;
    extraConfig = ''
      Defaults:root,%wheel env_keep+=SHLVL
    ''; # Fix sudo shlvl
  };
  # Nix
  programs.nh = {
    enable = true;
  };
  nix = {
    enable = true;
    package = pkgs.lixPackageSets.stable.lix;
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    settings.experimental-features = ["nix-command" "flakes"];
  };

  # Nixpkgs
  nixpkgs = {
    config.allowUnfree = true;
    config.joypixels.acceptLicense = true;
    overlays = [
      (final: prev: {
        inherit
          (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      })
    ];
  };

  # Firmware
  services.fwupd.enable = true;
  hardware.enableAllFirmware = true;

  # Networking
  networking.networkmanager.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # Remove bloat
  documentation.nixos.enable = false;
}
