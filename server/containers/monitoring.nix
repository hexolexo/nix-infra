{...}: {
  containers.grafana = {
    autoStart = true;
    privateNetwork = false;
    config = {
      config,
      pkgs,
      ...
    }: {
      services = {
        grafana = {
          enable = true;
          settings = {
            server = {
              http_addr = "0.0.0.0";
              http_port = 8080;
              domain = "localhost";
              serve_from_sub_path = true;
              dataDir = "/var/lib/grafana";
            };
          };
        };
      };
      networking.firewall.allowedTCPPorts = [8080];

      security.sudo.enable = false;
      users.users.root.hashedPassword = "!";

      #environment.systemPackages = lib.mkForce [ pkgs.coreutils ];
      system.stateVersion = "25.05";
    };
  };

  services.prometheus = {
    enable = true;
    port = 9090;
    scrapeConfigs = [
      {
        job_name = "endlessh-go";
        static_configs = [
          {
            targets = ["localhost:2112"]; # Default prometheus port for endlessh-go
          }
        ];
      }
      {
        job_name = "node-exporter";
        static_configs = [
          {
            targets = ["localhost:9100"];
          }
        ];
      }
    ];
    exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [
        #"cpu"
        #"meminfo"
        #"diskstats"
        #"filesystem"
        #"netdev"
        #"netstat"
        "systemd"
        #"thermal_zone"
        #"loadavg"
        #"pressure"
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [8080];
}
