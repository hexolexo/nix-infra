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
          loopbackIPs = ["192.168.1.153"];
        }
        {
          sourcePort = 26950; # Blade and Sorcery AMP
          proto = "tcp";
          destination = "192.168.122.78:26950";
          loopbackIPs = ["192.168.1.153"];
        }
      ];
    };

    firewall = {
      checkReversePath = "loose";
      trustedInterfaces = ["virbr0" "virbr1"];
      allowedTCPPorts = [26950];
      allowedUDPPorts = [26950];
      extraCommands = ''
        iptables -A FORWARD -i enp0s25 -o virbr0 -p tcp --dport 26950 -d 192.168.122.78 -j ACCEPT
        iptables -A FORWARD -i enp0s25 -o virbr0 -p udp --dport 26950 -d 192.168.122.78 -j ACCEPT
      '';
    };
  };
}
