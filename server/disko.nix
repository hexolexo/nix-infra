{
  disko.devices = {
    disk.root = {
      type = "disk";
      device = "/dev/vda"; # sdb on real hardware
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02";
          };
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
      device = "/dev/vdb"; # sda on real hardware
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
