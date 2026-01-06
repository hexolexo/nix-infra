{secrets, ...}: {
  networking.hostName = "hexolexo";

  networking.networkmanager.enable = true;

  networking.hosts = {
    "${secrets.HomeIP}" = ["home"];
    "${secrets.ServerIP}" = ["server"];
  };
  environment.etc."proxychains.conf".text = ''
    proxy_dns

    tcp_read_time_out 15000
    tcp_connect_time_out 8000

    # Proxy chain type
    strict_chain

    [ProxyList]
    socks5 127.0.0.1 1080
  '';
  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["10.0.0.2/24"];

      privateKeyFile = "/etc/wireguard/privkey";

      peers = [
        {
          publicKey = "p6qJwxfNS8cj+MNyBQSWCouPlwzz1MrwLOYObE48iBk=";
          endpoint = "${secrets.HomeIP}:51820";

          allowedIPs = ["10.0.0.0/24"];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
