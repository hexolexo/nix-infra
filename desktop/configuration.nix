{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./fanCtrl.nix
  ];
  nixpkgs.config.allowUnfree = true;
  security.polkit.enable = true;
  services.udisks2.enable = true;
  services.dbus.enable = true;
  programs.dconf.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hexolexo";

  networking.networkmanager.enable = true;

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
  users.users.hexolexo = {
    isNormalUser = true;
    description = "hexolexo";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  environment.systemPackages = with pkgs; [
    # Applications
    anki
    gnome-disk-utility
    libreoffice # fucking docx
    librewolf
    obsidian

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

    # Development
    cargo
    clang
    elmPackages.elm-language-server
    git
    go
    gopls
    jq
    lua-language-server
    marksman
    micro
    nil
    alejandra
    nix-output-monitor
    nodePackages.bash-language-server
    opentofu
    pkg-config
    ripgrep
    rustc
    neovim
    unzip

    # Shell/Terminal
    btop
    fzf
    highlight
    pass
    starship
    zoxide
    mutagen
    vhs

    # System Tools
    borgbackup
    brightnessctl
    ffmpeg
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
    mpd = {
      enable = true;
      user = "hexolexo";
      group = "users";
      musicDirectory = "/home/hexolexo/Music";
      extraConfig = ''
        audio_output {
            type "pulse"
            name "PulseAudio"
            server "/run/user/1000/pulse/native"
        }
      '';
    };
    keyd = {
      enable = true;
      keyboards.default = {
        ids = ["*"];
        settings = {
          main = {
            capslock = "backspace";
            backspace = "noop";
            rightalt = "esc";
            esc = "noop";
          };
        };
      };
    };
    displayManager.ly.enable = true;
    blueman.enable = true;

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "colemak";
      };
    };
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

  security.rtkit.enable = true;
  console.keyMap = "colemak";

  programs = {
    kdeconnect.enable = true;
    firefox.enable = true;
    steam.enable = true;
    hyprland.enable = true;
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

  services.fanControl = {
    enable = true;
    allowedUsers = ["hexolexo"];
    quietDuty = 40;
    maxDuty = 100;
  };

  programs.gnupg.agent = {
    enable = true;
    #enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  services.logind.settings.Login = {
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitch = "ignore";
  };

  networking.networkmanager.wifi.powersave = false;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  services.pcscd.enable = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings.experimental-features = ["nix-command" "flakes"];
  };

  system.autoUpgrade = {
    enable = true;
    # operations = "boot";
    dates = "04:00";
    allowReboot = false;
  };

  system.stateVersion = "25.05";
}
