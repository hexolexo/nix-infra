{...}: {
  age.secrets.libvirtkey = {
    file = ../secrets/libvirtNATS.age;
    owner = "hexolexo";
    mode = "0400";
  };
  age.secrets.wireguardkey = {
    file = ../secrets/wireguardNATS.age;
    owner = "hexolexo";
    mode = "0400";
  };

  services.nats = {
    enable = true;
    settings = {
      host = "10.0.0.1";
      authorization = {
        users = [
          {
            # User Key
            nkey = "UAAHP3OLG6XC6XKMNBRAWXADF4SQG6UKFFBZD2B45UW25KEN4OYFO3EM";
            permissions = {
              publish = ["libvirt.>" "wg.>"];
              subscribe = ["_INBOX.>"];
            };
          }
          {
            # Libvirt listener
            nkey = "UDOLBO4NERUUR2E7V7YBCG7K7UIXUKE2ITKKKRT7FGXE5RTU4PE5NQT5";
            permissions = {
              publish = ["libvirt.>" "wg.>" "_INBOX.>"];
              subscribe = ["libvirt.>" "_INBOX.>"];
            };
          }
          {
            # Wireguard listener
            nkey = "UBF64LLZCAUMJ6ITZPJ4J4NW25NUXKTH6WDMCUCGD5F3FNKGEQUUVM7Q";
            permissions = {
              publish = ["wg.>" "_INBOX.>"];
              subscribe = ["wg.>" "_INBOX.>"];
            };
          }
        ];
      };
      port = 4222;
    };
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [4222];
}
