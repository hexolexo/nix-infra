{
  config,
  lib,
  secrets,
  ...
}: {
  networking = {
    # Primary NAT: VMs to internet
    nat = {
      enable = true;
      internalInterfaces = ["virbr0" "virbr1"];
      externalInterface = "enp0s25";
    };

    firewall = {
      checkReversePath = "loose";
      trustedInterfaces = ["virbr0" "virbr1"];
      allowedTCPPorts = lib.optional (config.services.i2pd.enable or false) 7070;
    };
  };
  networking.nat.forwardPorts = lib.optionals (config.services.i2pd-container.enable or false) [
    {
      destination = "192.168.100.1:${secrets.I2PPort}";
      sourcePort = secrets.I2PPort;
      proto = "tcp";
    }
  ];
  networking.firewall.interfaces.wg0.allowedTCPPorts =
    lib.optional (config.services.i2pd-container.enable or false) 7070;
  networking.firewall.interfaces.virbr0.allowedTCPPorts =
    lib.optional (config.services.i2pd-container.enable or false) 7070;
}
