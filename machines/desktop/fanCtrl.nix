{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.fanControl;
in {
  options.services.fanControl = {
    enable = mkEnableOption "fan control services";

    package = mkOption {
      type = types.package;
      default = pkgs.fw-ectool;
      description = "The fw-ectool package to use";
    };

    interface = mkOption {
      type = types.str;
      default = "lpc";
      description = "Interface to use for ectool";
    };

    quietDuty = mkOption {
      type = types.int;
      default = 40;
      description = "Fan duty cycle percentage for quiet mode";
    };

    maxDuty = mkOption {
      type = types.int;
      default = 100;
      description = "Fan duty cycle percentage for max mode";
    };

    allowedUsers = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Users allowed to control fan services without password";
      example = ["username"];
    };
  };

  config = mkIf cfg.enable {
    systemd.services = {
      fanAutoControl = {
        description = "Enable automatic fan control";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${cfg.package}/bin/ectool --interface=${cfg.interface} autofanctrl";
          User = "root";
        };
      };

      fanQuiet = {
        description = "Set fan to quiet mode";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${cfg.package}/bin/ectool --interface=${cfg.interface} fanduty ${toString cfg.quietDuty}";
          User = "root";
        };
      };

      fanMax = {
        description = "Set fan to maximum speed";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${cfg.package}/bin/ectool --interface=${cfg.interface} fanduty ${toString cfg.maxDuty}";
          User = "root";
        };
      };
    };

    security.sudo.extraRules = mkIf (cfg.allowedUsers != []) [
      {
        users = cfg.allowedUsers;
        commands = [
          {
            command = "/run/current-system/sw/bin/systemctl start fanAutoControl";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/systemctl start fanQuiet";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/systemctl start fanMax";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
