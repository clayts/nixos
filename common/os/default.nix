{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./desktop.nix
    ./steam.nix
    ./home-manager.nix
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
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
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
  environment.systemPackages = [
    (pkgs.aspellWithDicts (dicts: [
      dicts.en
      dicts.en-computers
      dicts.en-science
    ]))
  ];

  # Suspend
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=24h
  '';
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  # Zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Sudo
  security.sudo.wheelNeedsPassword = false;
  security.sudo.extraConfig = ''
    Defaults:root,%wheel env_keep+=SHLVL
  ''; # Fix sudo shlvl

  # Nix
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  programs.nh = {
    enable = true;
  };
  nix = {
    enable = true;
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };
  ## Allow unfree and experimental
  nixpkgs.config.allowUnfree = true;
  ## Prevents annoying error messages
  system.activationScripts.empty-channel = {
    text = ''
      mkdir -p /nix/var/nix/profiles/per-user/root/channels
    '';
  };

  # Firmware
  services.fwupd.enable = true;
  hardware.enableAllFirmware = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
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
