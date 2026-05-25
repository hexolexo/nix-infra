{...}: {
  services.ollama = {
    enable = true;
    host = "10.0.0.1";
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [11434];
}
