{pkgs, ...}: {
  programs.steam.enable = true;

  users.users.steam = {
    isNormalUser = true;
    home = "/var/lib/steam";
    group = "steam";
    extraGroups = ["video" "render" "audio" "input"];
  };
  users.groups.steam = {};

  systemd.services.steam-big-picture = {
    description = "Steam Big Picture";
    wantedBy = ["multi-user.target"];
    after = ["weston.service" "sunshine.service"];
    requires = ["weston.service"];
    serviceConfig = {
      User = "steam";
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "5s";
      # WARN: -pipewire-dmabuf will silently do nothing if pipewire isn't running
      ExecStart = "${pkgs.steam}/bin/steam -tenfoot -pipewire-dmabuf";
      RuntimeDirectory = "steam-session";
      RuntimeDirectoryMode = "0700";
      StateDirectory = "steam";
      StandardOutput = "journal";
      StandardError = "journal";
    };
    environment = {
      XDG_RUNTIME_DIR = "/run/steam-session";
      WAYLAND_DISPLAY = "wayland-1";
      # weston socket is owned by sunshine user — steam user needs to reach it
      # WARN: this will fail if RuntimeDirectoryMode on weston is 0700
      HOME = "/var/lib/steam";
      DISPLAY = "";
      XDG_SESSION_TYPE = "wayland";
      XDG_DATA_HOME = "/var/lib/steam/.local/share";
      # stop steam phoning home for shader caching to a path it can't write
      STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "0";
    };
  };
}
