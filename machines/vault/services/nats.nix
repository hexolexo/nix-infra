{pkgs, ...}: {
  services.nats = {
    enable = true;
    settings = {
      port = 4222;
    };
  };
  networking.firewall.allowedTCPPorts = [4222];
}
