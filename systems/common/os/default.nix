{
  pkgs,
  inputs,
  hostname,
  ...
}: {
  imports = [
    ./shell
    ./desktop

    ./home-manager.nix
  ];

  # Version
  system.stateVersion = "24.11";

  # Hostname
  networking.hostName = hostname;

  # Boot
  boot = {
    ## Kernel
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    ## Boot loader
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
  # environment.systemPackages = with pkgs; [
  #   aspellDicts.en
  #   aspellDicts.en-computers
  #   aspellDicts.en-science
  # ];
  environment.systemPackages = [(pkgs.aspellWithDicts (dicts: [dicts.en]))];

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

  # User settings
  environment.localBinInPath = true;
  environment.variables = {
    XDG_CONFIG_HOME = "$HOME/.config";
  };
  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=.Desktop
    DOWNLOAD=Downloads
    TEMPLATES=.Templates
    PUBLICSHARE=.Public
    DOCUMENTS=Documents
    MUSIC=Music
    PICTURES=Pictures
    VIDEOS=Videos
  '';
}
