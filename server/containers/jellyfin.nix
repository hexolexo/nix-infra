{...}: {
  # Enable NVIDIA drivers
  hardware.nvidia.open = false; # Fuck you nvidia
  # For hardware acceleration support
  hardware.graphics.enable = true;
  containers.jellyfin = {
    autoStart = true;
    bindMounts = {
      "/var/lib/jellyfin" = {
        hostPath = "/var/lib/containers/jellyfin";
        isReadOnly = false;
      };
    };
    config = {
      pkgs,
      lib,
      ...
    }: {
      users.groups.multimedia = {};
      users.users.jellyfin = {
        isSystemUser = true;
        group = "multimedia";
        extraGroups = ["multimedia"];
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/jellyfin/media 0770 jellyfin multimedia - -"
      ];

      services.jellyfin = {
        enable = true;
        openFirewall = true;
        group = "multimedia";
      };

      system.stateVersion = "25.05";
    };
  };

  networking.firewall.allowedTCPPorts = [8096];
}
