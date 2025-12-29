{
  pkgs,
  secrets,
  ...
}: {
  containers.i2pd-container = {
    autoStart = true;
    privateNetwork = false;
    config = {...}: {
      # Exposing the nessecary ports in order to interact with i2p from outside the container
      networking.firewall.allowedTCPPorts = [
        7070 # default web interface port
        4447 # default socks proxy port
        4444 # default http proxy port
      ];

      services.i2pd = {
        enable = true;
        address = "192.168.100.1";
        proto = {
          http.enable = true;
          socksProxy.enable = true;
          httpProxy.enable = true;
        };
      };
      system.stateVersion = "25.11"; # If you don't add a state version, nix will complain at every rebuild
    };
  };
  networking.firewall.allowedTCPPorts = [
    7070 # default web interface port
    4447 # default socks proxy port
    4444 # default http proxy port
  ];
}
