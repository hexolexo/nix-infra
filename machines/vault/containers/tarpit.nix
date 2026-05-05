{lib, ...}:
#let
#    unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
#in
{
  containers.endlessh = {
    autoStart = true;
    privateNetwork = false;
    extraFlags = [
      "--capability=CAP_NET_BIND_SERVICE"
    ];

    bindMounts = {
      "/var/log/endlessh" = {
        hostPath = "/var/log/containers/endlessh";
        isReadOnly = false;
      };
      "/run/maxmind_keys/" = {
        hostPath = "/var/maxmind_keys/";
        isReadOnly = true;
      };
    };
    config = {
      config,
      pkgs,
      ...
    }: {
      services = {
        endlessh-go = {
          enable = true;
          port = 22;
          extraOptions = [
            "-interval_ms 3000"
            "-enable_prometheus"
            "-prometheus_port 2112"
            #"-geoip_supplier ip-api"  # if maxmind stops working # though due to the amount I get can often get timed out
            "-geoip_supplier max-mind-db"
            "-max_mind_db /var/lib/GeoIP/GeoLite2-Country.mmdb"
          ];
        };
        geoipupdate = {
          enable = true;
          settings = {
            AccountID = 1183058;
            DatabaseDirectory = "/var/lib/GeoIP/";
            LicenseKey = {_secret = "/run/keys/maxmind_license_key";};
            EditionIDs = [
              "GeoLite2-Country"
            ];
          };
        };
      };

      systemd.services.endlessh-go = {
        after = ["network.target"];
        serviceConfig.BindReadOnlyPaths = [config.services.geoipupdate.settings.DatabaseDirectory];
      };

      # Open ports in container
      networking.firewall.allowedTCPPorts = [22 2112];

      security.sudo.enable = false;
      users.users.root.hashedPassword = "!";

      environment.systemPackages = lib.mkForce [pkgs.coreutils];
      system.stateVersion = "25.05";
    };
  };

  networking.firewall.allowedTCPPorts = [22];
}
