{
  config,
  lib,
  ...
}: {
  ### WHAT THE FUCK IS THIS ###
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
      allowedTCPPorts = lib.optional config.services.i2pd-container.enable 7070;

      extraCommands = ''
        ${lib.optionalString config.services.i2pd-container.enable ''
          # Secondary NAT: container to virbr0
          iptables -t nat -A POSTROUTING -s 192.168.152.0/24 -o virbr0 -j MASQUERADE

          # Forwarding
          iptables -A FORWARD -i ve-i2pd-container -o virbr0 -j ACCEPT
          iptables -A FORWARD -i virbr0 -o ve-i2pd-container -j ACCEPT

          # Port forward: host:7070 → container:7070
          iptables -t nat -A PREROUTING -p tcp --dport 7070 -j DNAT --to-destination 192.168.152.11:7070
        ''}
      '';
    };
  };
}
