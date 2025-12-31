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
          defaultGateway = "192.168.100.10";
          nameservers = ["192.168.100.1"]; # libvirt dnsmasq
          # Exposing the nessecary ports in order to interact with i2p from outside the
          firewall.allowedTCPPorts = [
            7070 # default web interface port
            4447 # default socks proxy port
            4444 # default http proxy port
          ];
        };

        services.i2pd = {
          enable = true;
          address = "192.168.152.11";
          proto = {
            http.enable = true;
            socksProxy.enable = true;
            httpProxy.enable = true;
          };
        };
        system.stateVersion = "25.11"; # If you don't add a state version, nix will complain at every rebuild
      };
    };
  };
  # networking config exists in virtual-networking.nix
}
