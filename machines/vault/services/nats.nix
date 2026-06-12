{...}: {
  services.nats = {
    enable = true;
    settings = {
      listen = "10.0.0.1:4000";
      port = 4000;
    };
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [4000];
}
