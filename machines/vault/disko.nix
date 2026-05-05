{
  disko.devices = {
    disk.root = {
      type = "disk";
      device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_500GB_S4FNNF0MC11780E";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "rpool";
            };
          };
        };
      };
    };

    disk.data = {
      type = "disk";
      device = "/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WCC4N7ZUY5XZ";
      content = {
        type = "gpt";
        partitions.data = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "dpool";
          };
        };
      };
    };

    zpool.rpool = {
      type = "zpool";
      rootFsOptions = {
        compression = "zstd";
        atime = "off";
        mountpoint = "none";
      };
      datasets = {
        root = {
          type = "zfs_fs";
          mountpoint = "/";
          options.mountpoint = "/";
        };
        nix = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options.mountpoint = "/nix";
        };
      };
    };

    zpool.dpool = {
      type = "zpool";
      rootFsOptions = {
        compression = "zstd";
        atime = "off";
        mountpoint = "none";
      };
      datasets.data = {
        type = "zfs_fs";
        mountpoint = "/data"; # radicle, VMs, etc go here
        options.mountpoint = "/data";
      };
    };
  };
}
