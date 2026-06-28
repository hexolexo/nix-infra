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
    #./virtualisation.nix
  ];

  boot.initrd.systemd.emergencyAccess = true;
  systemd.services.zfs-mount.enable = false;

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

  systemd.user.services.wivrn.environment = {
    XRT_COMPOSITOR_COMPUTE = "1";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    XRT_COMPOSITOR_FORCE_WAIT_FOR_PRESENT = "0";
  };
  systemd.user.services.wivrn.serviceConfig = {
    AmbientCapabilities = "CAP_SYS_NICE";
    CapabilityBoundingSet = "CAP_SYS_NICE";
  };
  systemd.timers.fwupd-refresh.enable = false;

  services.greetd = {
    enable = true;
    settings.initial_session = {
      command = "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
      user = "hexolexo";
    };
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd '${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop'";
      user = "greeter";
    };
  };

  services.openssh.enable = true;
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

  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin]; # if you use this, keep it

    package = pkgs.steam.override {
      extraEnv = {
        PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = "1";
        STEAM_BWRAP_ARGS = "--bind /home/hexolexo/.config/openxr /home/hexolexo/.config/openxr";
      };
    };
  };

  services.xserver.videoDrivers = ["amdgpu"];

  services.wivrn = {
    enable = true;
    openFirewall = true; # pokes UDP hole for streaming
  };
  services.hardware.openrgb.enable = true;

  nix.settings.substituters = ["https://attic.xuyh0120.win/lantian"];
  nix.settings.trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
  boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-latest-zen4;
  boot.zfs.package = config.boot.kernelPackages.zfs_cachyos;

  networking.firewall.interfaces."wg0".allowedTCPPorts = [8082];

  system.stateVersion = "25.11";

  nixpkgs.config.allowUnfree = true;

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
    # Desktop needs this too
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

  users.users.hexolexo = {
    isNormalUser = true;
    description = "hexolexo";
    initialPassword = "changeme";
    extraGroups = ["input" "networkmanager" "wheel"];
    packages = with pkgs; [
      # GUI
      obsidian
      freetube
      mumble
      # TUI
      nethack
      alacritty
      mpc
      mpv
      ncmpcpp
      btop
      starship
      fuzzel
      clipse
      feh
      zoxide
      eza
      grimblast
      jq
      go
      stylua
      delve
      mutagen
      neovim
      borgbackup
      wireguard-tools
      wl-clipboard
      yt-dlp
      hyprlock
      hyprpaper
      hyprpolkitagent
      quickshell
      qt6.qtwayland
    ];
  };

  environment.systemPackages = with pkgs; [
    pinentry-tty
    #monado-vulkan-layers
    vulkan-tools

    # Wayland/Desktop
    pamixer
    prismlauncher

    # VR
    android-tools
    protontricks
    xrizer
    wayvr

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
    #flatpak.enable = true;
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
    mpd = {
      enable = true;
      user = "hexolexo";
      group = "users";
      settings = {
        music_directory = "/home/hexolexo/Music";
        audio_output = [
          {
            type = "pulse";
            name = "PulseAudio/PipeWire";
            # WARN: hardcoded UID 1000 — breaks if hexolexo isn't the first user
            server = "/run/user/1000/pulse/native";
          }
        ];
      };
    };
  };

  programs = {
    coolercontrol.enable = true;

    firefox.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-tty;
    };
    dconf.enable = true;
    neovim.defaultEditor = true;
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
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "server";
        system = "x86_64-linux";
        sshUser = "nix-builder";
        sshKey = "/home/hexolexo/.ssh/id_ed25519";
        maxJobs = 20;
        speedFactor = 2;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
      }
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
    };
  };

  networking.firewall = {
    allowedTCPPorts = [];
    allowedUDPPorts = [];
  };
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  services.murmur = {
    enable = true;
    openFirewall = true;
  };
}
