{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  # User for sunshine to run under
  users.users.sunshine = {
    isNormalUser = true;
    extraGroups = ["video" "render" "input"];
    # WARN: Don't set initialPassword in prod, use hashedPassword instead
  };

  # Kernel modules for input devices
  boot.kernelModules = ["uinput"];

  # X server with virtual display
  services.xserver = {
    enable = true;

    # Use nvidia drivers (or "modesetting" for Intel/AMD)
    videoDrivers = ["dummy"];

    displayManager = {
      gdm.enable = true;
      defaultSession = "gnome";

      autoLogin = {
        enable = true;
        user = "sunshine";
      };
    };

    resolutions = [
      {
        x = 1920;
        y = 1080;
      }
      {
        x = 2560;
        y = 1440;
      }
    ];
    desktopManager.gnome.enable = true;
  };

  # NetworkManager needed for Steam to see networks
  networking.networkmanager.enable = true;

  # HACK: Wrap sunshine with capabilities for uinput access
  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${pkgs.sunshine}/bin/sunshine";
  };

  # Sunshine systemd user service
  # Runs in the graphical session after autologin
  systemd.user.services.sunshine = {
    description = "Sunshine streaming server";
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];

    startLimitIntervalSec = 500;
    startLimitBurst = 5;

    serviceConfig = {
      ExecStart = "${config.security.wrapperDir}/sunshine";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  # Firewall for Sunshine
  # HTTPS: 47984, HTTP: 47989, Web UI: 47990, RTSP: 48010, Control/Video/Audio: 47998-48000
  networking.firewall = {
    allowedTCPPorts = [47984 47989 47990 48010];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48000;
      }
      {
        from = 48010;
        to = 48010;
      }
    ];
  };

  # Optional: Steam for game streaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # Hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # For 32-bit games
  };

  # Nvidia specific config
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false; # WARN: Can cause issues on servers
    open = false; # Use proprietary driver
    nvidiaSettings = true;
  };
}
