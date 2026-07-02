{
  pkgs,
  inputs,
  config,
  ...
}: let
  global = import ../vault/global.nix;
in {
  imports = [
    ./hardware-configuration.nix
    ../shared/keyd.nix
    ./networking.nix
    ./audio.nix
    ./vr.nix
    ./desktop.nix
    ./eraseyourdarlings.nix
    #./virtualisation.nix
  ];

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "hexolexo-pc";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      wifi.powersave = false;
    };
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = false;
    };
  };

  systemd.timers.fwupd-refresh.enable = false;

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  users.users = {
    hexolexo.openssh.authorizedKeys.keys = global.laptopKey;
    root.openssh.authorizedKeys.keys = global.laptopKey;
  };

  boot.initrd.kernelModules = ["amdgpu"];

  boot.supportedFilesystems = ["zfs"];
  boot.zfs.forceImportRoot = false; # don't force-import on boot; safer for non-root pools

  networking.hostId = "471d3a3f";

  services.zfs.autoScrub.enable = true; # run monthly scrubs; highly recommended

  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
  ];

  boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-latest-zen4;
  boot.zfs.package = config.boot.kernelPackages.zfs_cachyos;

  security = {
    pam.u2f = {
      enable = true;
      control = "sufficient";
    };
    pam.services = {
      sudo.u2fAuth = true;
      login.u2fAuth = true;
    };
    polkit.enable = true;
    rtkit.enable = true;
  };

  documentation.man.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "Australia/Sydney";

  i18n = {
    defaultLocale = "en_AU.UTF-8";
    extraLocaleSettings = {
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
  };

  environment.systemPackages = with pkgs; [
    pinentry-tty
    #monado-vulkan-layers
    vulkan-tools

    # Wayland/Desktop
    pamixer
    prismlauncher

    # Development
    git
    lua-language-server
    marksman
    micro
    python3 # Man I fuckin hate python
    nil
    alejandra
    nix-output-monitor
    unzip

    # Shell/Terminal
    fzf
    ripgrep
    fd
    highlight
    pass
    vhs
    gum
    caligula

    # System Tools
    ffmpeg-full

    socat
  ];

  services = {
    udisks2.enable = true;
    dbus.enable = true;
    fwupd.enable = true;
    blueman.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;

      wireplumber.extraConfig."10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.roles" = ["a2dp_sink" "a2dp_source"];
        };
      };
    };
  };

  fonts.packages = [pkgs.nerd-fonts.fira-code];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [rocmPackages.clr.icd];
    };
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      substituters = ["https://attic.xuyh0120.win/lantian"];
      trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];

      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
    };
  };

  networking.firewall = {
    allowedTCPPorts = [];
    allowedUDPPorts = [];
  };

  system.stateVersion = "25.11";
}
