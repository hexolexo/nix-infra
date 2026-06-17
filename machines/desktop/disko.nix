{lib, ...}: {
  disko.devices = {
    disk.main = {
      # WARN: set this to your actual disk — check with lsblk
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
            # takes remaining space
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
        ashift = "12"; # WARN: assumes 4K sector disk — verify with `smartctl -i /dev/nvme0n1`
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
        "system" = {
          type = "zfs_fs";
          options = {
            mountpoint = "none";
            canmount = "off";
          };
        };
        "system/root" = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/";
        };
        "user" = {
          type = "zfs_fs";
          options = {
            mountpoint = "none";
            canmount = "off";
          };
        };
        "user/home" = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/home";
        };
      };
    };
  };
}
