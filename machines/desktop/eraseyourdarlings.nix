{pkgs, ...}: {
  boot.initrd.systemd.services.rollback = {
    description = "Rollback ZFS root to blank snapshot";
    wantedBy = ["initrd.target"];
    after = ["zfs-import-rpool.service"];
    before = ["sysroot.mount"];
    unitConfig.DefaultDependencies = "no";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.zfs}/bin/zfs rollback -r rpool/local/root@blank";
    };
  };

  systemd.tmpfiles.rules = [
    "L /etc/NetworkManager/system-connections - - - - /persist/etc/NetworkManager/system-connections"
    "d /var/lib/bluetooth 0700 root root - -"
    #"L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
    "L /var/lib/mpd - - - - /persist/var/lib/mpd"
  ];

  fileSystems."/var/lib/bluetooth" = {
    device = "/persist/var/lib/bluetooth";
    fsType = "none";
    options = ["bind"];
  };
}
