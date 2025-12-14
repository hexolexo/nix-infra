{pkgs, ...}: let
  secrets = import ./secrets.nix;
in {
  containers.i2p-container = {
    autoStart = true;
    privateNetwork = false;
    bindMounts = {
      "/var/lib/i2p" = {
        hostPath = "/var/lib/containers/i2p";
        isReadOnly = false;
      };
    };

    config = {...}: {
      users.users.i2p-tunnel = {
        isNormalUser = true;
        description = "I2P tunnel user for port forwarding";
        extraGroups = [];
        shell = pkgs.shadow;
      };

      services.openssh = {
        enable = true;
        ports = [2222];
        settings = {
          AllowTcpForwarding = true;
          ForceCommand = "/run/current-system/sw/bin/sleep infinity";
          GatewayPorts = "yes";
          PasswordAuthentication = true;
          PermitRootLogin = "no";
        };
      };

      networking.firewall = {
        allowedUDPPorts = [
          secrets.i2p_port
        ];
        allowedTCPPorts = [
          2222 # SSH
          7657
          #7070 # web ui
          4447 # socks proxy
          4445
          4444 # http proxy
          secrets.i2p_port
        ];
      };
      services.i2p.enable = true; #  TODO: Move to I2Pd
      system.stateVersion = "25.05";
    };
  };
  networking.firewall = {
    allowedUDPPorts = [
      secrets.i2p_port
    ];
    allowedTCPPorts = [
      2222 # SSH port for forwarding
      secrets.i2p_port
    ];
    extraCommands = ''
      iptables -A INPUT -p tcp --dport 2222 -s 192.168.122.0/24 -j ACCEPT
      iptables -A INPUT -p tcp --dport 2222 -j DROP
    ''; # Only allow VMs to access this port
  };
}
