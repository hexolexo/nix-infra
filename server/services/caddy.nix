{...}: {
  services.caddy = {
    enable = true;
    # Individual vhosts are merged in from each service file
  };

  # Open ports on the WG interface - adjust interface name to yours
  networking.firewall.interfaces."wg0" = {
    allowedTCPPorts = [80 443];
  };
}
