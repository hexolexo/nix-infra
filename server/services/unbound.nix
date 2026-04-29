{...}: {
  services.unbound = {
    enable = true;
    settings.server = {
      interface = ["10.0.0.1" "127.0.0.1"]; # HACK: hardcoded WG IP, match yours
      access-control = [
        "10.0.0.0/24 allow" # adjust subnet to yours
        "127.0.0.0/8 allow"
        "0.0.0.0/0 refuse"
      ];
      local-zone = [''"homelab.internal." static''];
    };
    settings.forward-zone = [
      {
        name = ".";
        forward-addr = ["1.1.1.1" "8.8.8.8"];
      }
    ];
  };

  networking.firewall.interfaces."wg0".allowedUDPPorts = [53];
}
