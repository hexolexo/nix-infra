{pkgs, ...}: {
  services.nats = {
    enable = true;
    settings = {
      authorization = {
        users = [
          {
            nkey = "UAAHP3OLG6XC6XKMNBRAWXADF4SQG6UKFFBZD2B45UW25KEN4OYFO3EM";
            permissions = {
              publish = "libvirt.>";
              subscribe = "libvirt.>";
            };
          }
        ];
      };
      port = 4222;
    };
  };
  networking.firewall.allowedTCPPorts = [4222];
}
