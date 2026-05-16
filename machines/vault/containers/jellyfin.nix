{...}: {
  users.users.jellyfin = {
    isSystemUser = true;
    uid = 274;
    group = "multimedia";
  };
  systemd.tmpfiles.rules = [
    "d /data/jellyfin 0770 jellyfin multimedia - -"
  ];
  users.groups.multimedia = {};
  # Enable NVIDIA drivers
  containers.jellyfin = {
    autoStart = true;
    bindMounts = {
      "/var/lib/jellyfin" = {
        hostPath = "/data/jellyfin";
        isReadOnly = false;
      };
    };
    config = {
      pkgs,
      lib,
      ...
    }: {
      users.groups.multimedia = {
        gid = 274;
      };
      users.users.jellyfin = {
        isSystemUser = true;
        uid = 274;
        group = "multimedia";
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
