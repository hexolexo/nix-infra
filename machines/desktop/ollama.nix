{...}: {
  services.ollama = {
    enable = true;
    host = "10.0.0.8";
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [11434];
}
