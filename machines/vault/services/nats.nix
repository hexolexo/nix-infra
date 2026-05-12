{pkgs, ...}: {
  age.secrets.libvirtkey = {
    file = ../secrets/libvirtNATS.age;
    owner = "hexolexo";
    mode = "0400";
  };

  services.nats = {
    enable = true;
    settings = {
      authorization = {
        users = [
          {
            # User Key
            nkey = "UAAHP3OLG6XC6XKMNBRAWXADF4SQG6UKFFBZD2B45UW25KEN4OYFO3EM";
            permissions = {
              publish = ["libvirt.>"];
              subscribe = ["_INBOX.>"];
            };
          }
          {
            # Libvirt listener
            nkey = "UDOLBO4NERUUR2E7V7YBCG7K7UIXUKE2ITKKKRT7FGXE5RTU4PE5NQT5";
            permissions = {
              publish = ["_INBOX.>"];
              subscribe = ["libvirt.>"];
            };
          }
        ];
      };
      port = 4222;
    };
  };
  networking.firewall.allowedTCPPorts = [4222];
}
