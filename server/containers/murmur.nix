{...}: {
  containers.jitsi = {
    autoStart = true;
    config = {
      pkgs,
      lib,
      ...
    }: {
      services.murmur = {
        enable = true;
        openFirewall = true;
        #settings.bindaddr = "10.0.0.1"; # apaently this doesn't exist
        #password = "your-server-password"; # Optional server password
      };
      system.stateVersion = "25.05";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [64738];
    allowedUDPPorts = [64738];
  };
}
