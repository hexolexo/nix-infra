{...}: {
  networking.networkmanager.enable = true;

  networking.hosts = {
    "192.168.1.153" = ["home"];
    "10.0.0.1" = ["server"];
  };
  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["10.0.0.8/24"];

      privateKeyFile = "/etc/wireguard/privkey";

      peers = [
        {
          publicKey = "p6qJwxfNS8cj+MNyBQSWCouPlwzz1MrwLOYObE48iBk=";
          endpoint = "192.168.1.153:51820";

          allowedIPs = ["10.0.0.0/24"];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
