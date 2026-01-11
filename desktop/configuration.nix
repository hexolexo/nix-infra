{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./keyd.nix
    ./fanCtrl.nix
  ];
  nixpkgs.config.allowUnfree = true;
  security.polkit.enable = true;
  documentation.man.enable = true;
  # Bootloader.
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
    shell = pkgs.fish;
    extraGroups = [
      "input"
      "networkmanager"
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    # Applications
    #libreoffice # fucking docx
    librewolf
    obsidian
    moonlight-qt
    fluffychat

    # Theming
    (catppuccin-gtk.override {
      accents = ["lavender"];
      variant = "mocha";
    })
    libsForQt5.qtstyleplugin-kvantum
    (catppuccin-kvantum.override {
      accent = "lavender";
      variant = "mocha";
    })
    libsForQt5.qt5ct

    # Wayland/Desktop
    alacritty
    clipse
    eww
    feh
    glib
    grimblast
    mpc
    mpv
    ncmpcpp
    pamixer
    pinentry-tty
    polkit_gnome
    prismlauncher
    swaybg
    swaylock-effects
    waybar
    fuzzel
    evsieve

    # Development
    cargo
    clang
    gcc
    elmPackages.elm-language-server
    git
    go
    gopls
    go-tools
    jq
    lua-language-server
    marksman
    micro
    nil
    alejandra
    nix-output-monitor
    nodePackages.bash-language-server
    shfmt
    opentofu
    pkg-config
    rustc
    neovim
    unzip

    # Shell/Terminal
    btop
    fzf
    ripgrep
    fd
    highlight
    pass
    mutagen
    vhs

    # System Tools
    borgbackup
    brightnessctl
    ffmpeg-full
    libxkbcommon
    socat
    wireguard-tools
    wl-clipboard
    yt-dlp

    # Virtualisation
    spice
    spice-gtk
    spice-protocol
    virt-manager
    virt-viewer
    virtio-win
    win-spice
  ];

  environment.variables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  services = {
    udisks2.enable = true;
    dbus.enable = true;

    fanControl = {
      enable = true;
      allowedUsers = ["hexolexo"];
      quietDuty = 40;
      maxDuty = 100;
    };

    # Keeps the laptop running while lid is closed
    logind.settings.Login = {
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitch = "ignore";
    };

    fwupd.enable = true;
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
            server = "/run/user/1000/pulse/native";
          }
        ];
      };
    };

    displayManager.ly.enable = true;
    blueman.enable = true;

    printing.enable = true;
    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  programs = {
    firefox.enable = true;
    steam.enable = true;
    hyprland.enable = true;
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
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  networking.networkmanager.wifi.powersave = false;

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [];
    allowedUDPPorts = [];
  };

  system.stateVersion = "25.05";
}
