{secrets, ...}: {
  containers.i2pd = {
    autoStart = true;
    privateNetwork = false;
    config = {...}: {
      networking = {
        # Exposing the nessecary ports in order to interact with i2p from outside the
        firewall.allowedTCPPorts = [
          # Apparently these are required despite privateNetwork = false; ... Yeah I don't fking know either
          7070 # default web interface port
          4447 # default socks proxy port
          4444 # default http proxy port
          secrets.I2P_Port
        ];
        firewall.allowedUDPPorts = [
          secrets.I2P_Port
        ];
      };

      services.i2pd = {
        enable = true;
        port = secrets.I2P_Port;
        enableIPv6 = true;
        address = "::";
        bandwidth = 4800; # KBps
        share = 80;
        ntcp2 = {
          enable = true;
          published = true;
        };

        ssu2 = {
          enable = true;
          published = true;
        };
        proto = {
          http = {
            enable = true;
            address = "192.168.122.1";
            port = 7070;
          };
          socksProxy = {
            enable = true;
            address = "192.168.122.1";
            port = 4447;
          };
          httpProxy = {
            enable = true;
            address = "192.168.122.1";
            port = 4444;
          };
        };
      };
      system.stateVersion = "25.11"; # If you don't add a state version, nix will complain at every rebuild
    };
  };
  networking = {
    firewall.allowedTCPPorts = [
      secrets.I2P_Port
    ];
    firewall.allowedUDPPorts = [
      secrets.I2P_Port
    ];
  };
}
