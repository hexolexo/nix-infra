{
  config,
  secrets,
  ...
}: {
  age.secrets.conduit-libvirt = {
    file = ../secrets/libvirtNATS.age;
    owner = "root";
    mode = "0400";
  };
  age.secrets.conduit-wireguard = {
    file = ../secrets/wireguardNATS.age;
    owner = "root";
    mode = "0400";
  };

  age.secrets.conduit-nixos = {
    file = ../secrets/nixosNATS.age;
    owner = "root";
    mode = "0400";
  };

  networking.firewall.allowedTCPPorts = [4222];
  services.conduit.nats = {
    enable = true;
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
      {
        nkey = "UCSZMASGZSCMML4T7YAI4J5ODIMHNYCRXNLLAG7O3L2H6KMNYNDPY6WR";
        permissions = {
          publish = ["nix.listen"];
          subscribe = ["nix.rebuild.>"];
        };
      }
      {
        nkey = "UCRX62IKQWXZXMQW4JRNAIBPOJCQHU6ENGAOXSOR3PDDDSEDYIUOSUUT";
        permissions = {
          publish = ["nix.rebuild.>"];
          subscribe = ["nix.listen"];
        };
      }
    ];
  };

  services.conduit.libvirt-agent = {
    enable = true;
    natsURL = "nats://localhost:4222";
    nkeySeedFile = config.age.secrets.conduit-libvirt.path;
    flakePath = "git+http://10.0.0.1:3000/hexolexo/nix-vm.git";
    wireguard.hubPubKey = "p6qJwxfNS8cj+MNyBQSWCouPlwzz1MrwLOYObE48iBk=";
    wireguard.hubEndpoint = secrets.HomeIPv4;
  };

  services.conduit.wireguard-agent = {
    enable = true;
    natsURL = "nats://localhost:4222";
    nkeySeedFile = config.age.secrets.conduit-wireguard.path;
  };

  services.conduit.nixos-agent = {
    enable = true;
    natsURL = "nats://localhost:4222";
    nkeySeedFile = config.age.secrets.conduit-nixos.path;
    flakePath = "git+http://10.0.0.1/hexolexo/nix-infra.git#vault";
  };
}
