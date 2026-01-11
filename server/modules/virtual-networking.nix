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
      forwardPorts = [
        {
          sourcePort = 26950; # Blade and Sorcery AMP
          proto = "udp";
          destination = "192.168.122.78:26950";
        }
        {
          sourcePort = 26950; # Blade and Sorcery AMP
          proto = "tcp";
          destination = "192.168.122.78:26950";
        }
      ];
    };

    firewall = {
      checkReversePath = "loose";
      trustedInterfaces = ["virbr0" "virbr1"];
      allowedTCPPorts = [26950];
    };
  };
}
