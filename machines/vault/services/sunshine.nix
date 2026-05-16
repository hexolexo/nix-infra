{pkgs, ...}: {
  imports = [
    ./steam.nix
  ];
  users.users.sunshine = {
    isSystemUser = true;
    group = "sunshine";
    extraGroups = ["video" "render" "input" "tty" "seat" "uinput"];
    home = "/var/lib/sunshine";
    createHome = true;
  };
  users.groups.sunshine = {};
  users.groups.uinput = {};

  boot.kernelModules = ["vkms" "uinput"];

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="uinput", MODE="0660"
  '';

  systemd.services.weston = {
    description = "Weston headless compositor";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = "sunshine";
      ExecStart = "${pkgs.weston}/bin/weston --backend=drm --drm-device=card1 --socket=wayland-1 --config=/etc/sunshine-weston.ini";
      Restart = "on-failure";
      RestartSec = "5s";
      RuntimeDirectory = "sunshine-wayland";
      RuntimeDirectoryMode = "0755"; # sunshine needs to reach the socket; 0700 locks it out even as the same user
      StateDirectory = "sunshine";
      StandardOutput = "journal";
      StandardError = "journal";
    };
    environment = {
      XDG_RUNTIME_DIR = "/run/sunshine-wayland";
      HOME = "/var/lib/sunshine";
      LIBSEAT_BACKEND = "builtin"; # bypasses logind — system services don't have seats
      SEATD_VTBOUND = "0"; # no VT in headless; without this libseat will try to bind one and fail
    };
  };

  environment.etc."sunshine-weston.ini" = {
    text = ''
      [core]
      renderer=gl

      [output]
      name=Virtual-1
      # WARN: no mode line — VKMS negotiates its own; set resolution on the sunshine side if needed
    '';
  };

  systemd.services.sunshine = {
    description = "Sunshine game stream host";
    wantedBy = ["multi-user.target"];
    after = ["weston.service"];
    requires = ["weston.service"];
    serviceConfig = {
      User = "sunshine";
      ExecStart = "${pkgs.sunshine}/bin/sunshine";
      Restart = "on-failure";
      # WARN: CAP_SYS_ADMIN is broad; needed for KMS/DRM capture
      AmbientCapabilities = "CAP_SYS_ADMIN";
      CapabilityBoundingSet = "CAP_SYS_ADMIN";
      StandardOutput = "journal";
      StandardError = "journal";
    };
    environment = {
      XDG_RUNTIME_DIR = "/run/sunshine-wayland";
      WAYLAND_DISPLAY = "wayland-1";
      HOME = "/var/lib/sunshine";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [47984 47989 47990 48010];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48000;
      }
    ];
  };
}
