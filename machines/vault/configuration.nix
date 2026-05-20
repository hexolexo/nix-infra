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
    #./services/paperless-ngx.nix
    #./containers/unbound.nix
    #./containers/murmur.nix
    ./containers/copyparty.nix
    #./services/nats.nix
    ./services/conduit.nix
    ./services/ollama.nix
    #./services/ntfy.nix
    ./services/jellyfin.nix
    #./services/sunshine.nix
    #./containers/radicle.nix
    #./containers/mindustry.nix
    #./containers/terraria.nix      #  WARN: Untested
    #./containers/I2P.nix           # Closed due to I2Perception and probably won't come back ):
    #./containers/jellyfin.nix
    #./containers/fuzzing.nix       #  NOTE: I'll probably want to start using this at some point
    #./containers/monitoring.nix    #  NOTE: Functional but overkill for this project
    #./containers/tarpit.nix
    # Minecraft #
    #./services/minecraft/modded.nix
    #./services/minecraft/create-medieval.nix
    #./services/minecraft/vanilla.nix
  ];

  # Bootloader.
  boot = {
    initrd.supportedFilesystems = ["zfs"];

    supportedFilesystems = ["zfs"];
    zfs.forceImportRoot = false;
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
        "video"
        "render"
        "input"
        "tty"
        "seat"
      ];
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
    pkg-config
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
