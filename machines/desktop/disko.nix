{lib, ...}: {
  disko.devices = {
    disk.main = {
      #  WARN: set this to your actual disk — check with lsblk
      device = "/dev/disk/by-id/nvme-T-FORCE_TM8FFE002T_TPBF2503250100400331";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "rpool";
            };
          };
        };
      };
    };
    zpool.rpool = {
      type = "zpool";
      options = {
        ashift = "12"; #  WARN: assumes 4K sector disk — verify with `smartctl -i /dev/nvme0n1`
        autotrim = "on";
      };
      rootFsOptions = {
        acltype = "posixacl";
        xattr = "sa";
        dnodesize = "auto";
        normalization = "formD";
        mountpoint = "none";
        canmount = "off";
        compression = "zstd";
        "com.sun:auto-snapshot" = "false";
      };
      datasets = {
        # never backed up — reconstructible
        "local" = {
          type = "zfs_fs";
          options = {
            mountpoint = "none";
            canmount = "off";
          };
        };
        "local/nix" = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/nix";
        };
        "local/games" = {
          type = "zfs_fs";
          options = {
            mountpoint = "legacy";
            atime = "off";
            recordsize = "1M";
            compression = "lz4"; # game assets already compressed, zstd wastes cycles
          };
          mountpoint = "/var/lib/games";
        };

        # backed up via syncoid -> tank
        "safe" = {
          type = "zfs_fs";
          options = {
            mountpoint = "none";
            canmount = "off";
          };
        };
        "safe/root" = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/";
        };
        "safe/home" = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/home";
        };
      };
    };
  };
}
