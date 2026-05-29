{secrets, ...}: {
  networking.hostName = "hexolexo";
  # note to self don't fuck with DNS

  networking.networkmanager.enable = true;

  networking.hosts = {
    "${secrets.HomeIPv4}" = ["home"];
    "${secrets.HomeIP}" = ["home"]; # man why is IPv6 such a pain
    "${secrets.ServerIP}" = ["server"];
  };
  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["10.0.0.8/24"];

      privateKeyFile = "/etc/wireguard/privkey";

      peers = [
        {
          publicKey = "p6qJwxfNS8cj+MNyBQSWCouPlwzz1MrwLOYObE48iBk=";
          endpoint = "${secrets.HomeIPv4}:51820";

          allowedIPs = ["10.0.0.0/24"];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
