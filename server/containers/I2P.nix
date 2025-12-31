{
  pkgs,
  lib,
  config,
  secrets,
  ...
}: {
  options.services.i2pd-container.enable = lib.mkEnableOption "i2pd ";
  config = lib.mkIf config.services.i2pd-container.enable {
    containers.i2pd = {
      autoStart = true;
      privateNetwork = false;
      config = {...}: {
        networking = {
          # Exposing the nessecary ports in order to interact with i2p from outside the
          firewall.allowedTCPPorts = [
            7070 # default web interface port
            4447 # default socks proxy port
            4444 # default http proxy port
          ];
          firewall.allowedUDPPorts = [
            secrets.I2P_Port
          ];
        };

        services.i2pd = {
          enable = true;
          port = secrets.I2P_Port;
          address = "192.168.100.1";
          proto = {
            http = {
              enable = true;
              address = "192.168.100.1";
              port = 7070;
            };
            socksProxy = {
              enable = true;
              address = "192.168.100.1";
              port = 4447;
            };
            httpProxy = {
              enable = true;
              address = "192.168.100.1";
              port = 4444;
            };
          };
        };
        system.stateVersion = "25.11"; # If you don't add a state version, nix will complain at every rebuild
      };
    };
    networking.firewall.allowedUDPPorts = [
      secrets.I2P_Port
    ];
  };
  # networking config exists in virtual-networking.nix
}
