{pkgs, ...}: {
  users.users.hexolexo = {
    isNormalUser = true;
    description = "hexolexo";
    initialPassword = "changeme";
    extraGroups = ["input" "networkmanager" "wheel" "video" "render"];
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
      zk
    ];
  };

  programs = {
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

  services.murmur = {
    enable = true;
    openFirewall = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };
}
