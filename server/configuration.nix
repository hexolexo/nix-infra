{pkgs, ...}: let
  global = import ./global.nix;
in {
  imports = [
    # Required Services #
    ./hardware-configuration.nix
    ./services/connection.nix
    ./services/wireguard.nix
    ./services/git.nix
    ./services/virtualisation.nix
    # Optional Services: #
    #./services/paperless-ngx.nix
    #./containers/unbound.nix
    #./containers/murmur.nix
    #./services/apt-cacher-ng.nix
    #./services/minecraft.nix
    #./containers/mindustry.nix
    #./containers/terraria.nix      #  WARN: Untested
    #./containers/I2P.nix           #  BUG: ISP blocking port forwarding reducing it's efficacy
    #./containers/jellyfin.nix
    #./containers/fuzzing.nix       #  NOTE: I'll probably want to start using this at some point
    #./containers/monitoring.nix    #  NOTE: Functional but overkill for this project
    #./containers/tarpit.nix
  ];

  # Bootloader.
  boot = {
    enableContainers = true;
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  programs.fish.enable = true;
  users.users = {
    hexolexo = {
      isNormalUser = true;
      description = "hexolexo";
      shell = pkgs.fish;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [go];
      openssh.authorizedKeys.keys = global.authorisedKeys;
    };
    root.openssh.authorizedKeys.keys = global.authorisedKeys;
  };

  environment.systemPackages = with pkgs; [
    btop
    git
    gnumake
    micro
    cargo
    pkg-config
    alsa-lib.dev
    clang
  ];

  networking = {
    hostName = "vault";
    networkmanager.enable = true;
    firewall.enable = true;
    firewall.allowedTCPPorts = []; # NOTE: Firewall is configured per service bundle
  };

  system.autoUpgrade = {
    enable = true;
    dates = "16:00"; # NOTE: I'll dial this back when I get busy
    allowReboot = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = 20;
      cores = 0;
      auto-optimise-store = true;
    };
  };
  services.smartd.enable = true;

  system.stateVersion = "25.05";
}
