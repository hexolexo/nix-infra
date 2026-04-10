{...}: {
  age.secrets.wireguard-private = {
    file = ../../secrets/wireguard-hub-key.age;
    owner = "root";
    mode = "0400";
  };
  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["10.0.0.1/24"];

      listenPort = 51820;

      privateKeyFile = "/run/agenix/wireguard-private";

      peers = [
        {
          publicKey = "vWCeMXGBA2v5bV+kX/otvPi/+v9DSAzKnrBqqbbB31k=";
          allowedIPs = ["10.0.0.2/32"]; # fw-laptop
          persistentKeepalive = 25;
        }
        {
          publicKey = "v54b/A7ynLrcXBMcgJkf6vgzJgra8Z3BkaFHMy1RMWk=";
          allowedIPs = ["10.0.0.4/32"]; # death
          persistentKeepalive = 25;
        }
      ];
    };
  };
  networking.firewall.allowedUDPPorts = [51820];
}
