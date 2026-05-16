{pkgs, ...}: {
  users.users.sunshine = {
    isSystemUser = true;
    group = "sunshine";
    extraGroups = ["video" "render" "input" "tty" "seat" "uinput"]; # uinput needed for virtual devices
    home = "/var/lib/sunshine";
    createHome = true;
  };
  users.groups.sunshine = {};

  # uinput group must exist for virtual input devices
  users.groups.uinput = {};

  # Ensure uinput module is loaded and device is accessible
  boot.kernelModules = ["uinput"];
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="uinput", MODE="0660"
  '';

  systemd.services.weston = {
    description = "Weston headless compositor";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = "sunshine";
      # HACK: --width/height are arbitrary; just needs to be nonzero for sunshine to see a display
      ExecStart = "${pkgs.weston}/bin/weston --backend=headless --socket=wayland-1 --width=1920 --height=1080";
      Restart = "on-failure";
      RuntimeDirectory = "sunshine-wayland"; # owns /run/sunshine-wayland
      StateDirectory = "sunshine";
    };
    environment = {
      XDG_RUNTIME_DIR = "/run/sunshine-wayland";
      HOME = "/var/lib/sunshine";
      # WARN: Without this weston may try to connect to a seat and fail on a headless system
      LIBSEAT_BACKEND = "noop";
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
      # WARN: CAP_SYS_ADMIN is broad; sunshine needs it for KMS/DRM capture
      # but won't help you here since nouveau lacks atomic modesetting anyway
      AmbientCapabilities = "CAP_SYS_ADMIN";
      CapabilityBoundingSet = "CAP_SYS_ADMIN";
      # No RuntimeDirectory here — weston owns it, sunshine is a guest
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
