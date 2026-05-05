{...}: {
  containers.mindustry = {
    autoStart = true;
    privateNetwork = false;
    config = {
      pkgs,
      lib,
      ...
    }: {
      # System packages including Mindustry
      environment.systemPackages = with pkgs; [
        mindustry
        openjdk17 # Java runtime required for Mindustry server
        screen # For running server in background
        #curl # For downloading maps or mods
      ];

      # Create mindustry user for running the server
      users.groups.mindustry = {};
      users.users.mindustry = {
        isSystemUser = true;
        home = "/var/lib/mindustry";
        createHome = true;
        group = "mindustry";
        description = "Mindustry game server user";
      };

      # Networking configuration (handled by port forwarding above)
      networking.firewall.enable = false; # Container uses host networking

      # Systemd service for Mindustry server
      systemd.services.mindustry-server = {
        description = "Mindustry Game Server";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "simple";
          User = "mindustry";
          Group = "mindustry";
          WorkingDirectory = "/var/lib/mindustry";

          # Command to start the server
          # You can customize server settings here
          ExecStart = "${pkgs.screen}/bin/screen -dmS mindustry-server ${pkgs.mindustry}/bin/mindustry-server";
          #ExecStart = "${pkgs.mindustry}/bin/mindustry-server";

          # Restart the service if it fails
          Restart = "always";
          RestartSec = "10";

          # Security settings
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ReadWritePaths = ["/var/lib/mindustry"];
        };

        # Environment variables for the server
        environment = {
          # Set Java heap size (adjust based on your server's RAM)
          JAVA_OPTS = "-Xmx2G -Xms1G";
        };
      };

      # Configure log rotation
      services.logrotate = {
        enable = true;
        settings = {
          "/var/log/mindustry/*" = {
            daily = true;
            missingok = true;
            rotate = 7;
            compress = true;
            notifempty = true;
            create = "644 mindustry mindustry";
          };
        };
      };

      # Container-specific settings
      boot.isContainer = true;
      system.stateVersion = "25.05";
    };
  };
  networking.firewall.allowedTCPPorts = [6567];
  networking.firewall.allowedUDPPorts = [6567];
}
