{pkgs, ...}: {
  environment.systemPackages = [pkgs.weston];

  systemd.user.services.weston = {
    description = "Weston headless compositor";
    wantedBy = ["default.target"];
    serviceConfig = {
      ExecStart = "${pkgs.weston}/bin/weston --backend=headless --width=1920 --height=1080";
      Restart = "on-failure";
    };
    environment = {
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
  };

  systemd.user.services.sunshine = {
    description = "Sunshine game stream host";
    wantedBy = ["default.target"];
    after = ["weston.service"];
    requires = ["weston.service"];
    serviceConfig = {
      ExecStart = "${pkgs.sunshine}/bin/sunshine";
      Restart = "on-failure";
    };
    environment = {
      XDG_RUNTIME_DIR = "/run/user/1000";
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
