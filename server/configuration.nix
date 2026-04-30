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
    #./services/clankhare.nix # I still can't believe they convinced me to name it this
    ./services/unbound.nix
    #./services/caddy.nix
    #./services/sunshine.nix
    #./services/paperless-ngx.nix
    #./containers/unbound.nix
    #./containers/murmur.nix
    #./services/apt-cacher-ng.nix
    #./services/minecraft.nix
    ./containers/copyparty.nix
    #./containers/radicle.nix
    #./containers/mindustry.nix
    #./containers/terraria.nix      #  WARN: Untested
    #./containers/I2P.nix           # Closed due to I2Perception and probably won't come back ):
    #./containers/jellyfin.nix
    #./containers/fuzzing.nix       #  NOTE: I'll probably want to start using this at some point
    #./containers/monitoring.nix    #  NOTE: Functional but overkill for this project
    #./containers/tarpit.nix
  ];

  # Bootloader.
  boot = {
    initrd.supportedFilesystems = ["zfs"];

    supportedFilesystems = ["zfs"];
    enableContainers = true;
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
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
      initialPassword = "changeme";
      shell = pkgs.fish;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [go];
      openssh.authorizedKeys.keys = global.authorisedKeys;
    };
    nix-builder = {
      isNormalUser = true;
      description = "NixOS remote builder";
      openssh.authorizedKeys.keys = global.authorisedKeys;
    };
    root = {
      openssh.authorizedKeys.keys = global.authorisedKeys;
      initialPassword = "changeme";
    };
  };

  environment.systemPackages = with pkgs; [
    btop
    git
    gnumake
    alejandra
    micro
    nix-output-monitor
    cargo
    pkg-config
    alsa-lib.dev
    clang
  ];

  networking = {
    enableIPv6 = true;
    hosts = {
      "127.0.0.1" = ["server"];
    };

    hostName = "vault";
    networkmanager.enable = true;
    firewall.enable = true;
    firewall.allowedTCPPorts = []; # NOTE: Firewall is configured per service bundle
  };

  fileSystems."/data" = {
    device = "dpool/data";
    fsType = "zfs";
    options = ["zfsutil" "nofail"];
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      trusted-users = ["nix-builder"];
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

  system.stateVersion = "25.11";
}
