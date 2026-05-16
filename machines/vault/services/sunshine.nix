{pkgs, ...}: {
  users.users.sunshine = {
    isSystemUser = true;
    group = "sunshine";
    extraGroups = ["video" "render" "input" "tty" "seat"];
  };

  users.groups.sunshine = {};

  systemd.services.weston = {
    description = "Weston headless compositor";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = "sunshine";
      ExecStart = "${pkgs.weston}/bin/weston --backend=headless --width=1920 --height=1080";
      Restart = "on-failure";
      RuntimeDirectory = "sunshine-wayland";
    };
    environment = {
      XDG_RUNTIME_DIR = "/run/sunshine-wayland";
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
