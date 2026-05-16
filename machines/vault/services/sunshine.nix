{pkgs, ...}: {
  users.users.sunshine = {
    isSystemUser = true;
    group = "sunshine";
    extraGroups = ["video" "render" "input" "tty" "seat"];
    home = "/var/lib/sunshine";
    createHome = true;
  };

  users.groups.sunshine = {};

  systemd.services.weston = {
    description = "Weston headless compositor";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = "sunshine";
      ExecStart = "${pkgs.sunshine}/bin/sunshine";
      Restart = "on-failure";
      AmbientCapabilities = "CAP_SYS_ADMIN";
      CapabilityBoundingSet = "CAP_SYS_ADMIN";
      RuntimeDirectory = "sunshine-wayland";
      StateDirectory = "sunshine"; # creates /var/lib/sunshine
    };
    environment = {
      XDG_RUNTIME_DIR = "/run/sunshine-wayland";
      WAYLAND_DISPLAY = "wayland-1";
      HOME = "/var/lib/sunshine";
    };
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
      AmbientCapabilities = "CAP_SYS_ADMIN";
      CapabilityBoundingSet = "CAP_SYS_ADMIN";
      RuntimeDirectory = "sunshine-wayland";
    };
    environment = {
      XDG_RUNTIME_DIR = "/run/sunshine-wayland";
      WAYLAND_DISPLAY = "wayland-1";
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
