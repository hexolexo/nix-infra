{secrets, ...}: {
  age = {
    identityPaths = ["/home/hexolexo/.ssh/id_ed25519"];
    secrets.wireguard-private = {
      file = ../secrets/wireguard-hexolexo-key.age;
      owner = "root";
      mode = "0400";
    };
  };

  networking.hostName = "hexolexo";

  networking.networkmanager.enable = true;

  networking.hosts = {
    "${secrets.HomeIPv4}" = ["home"];
    "${secrets.HomeIP}" = ["home"]; # man why is IPv6 such a pain
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

      privateKeyFile = "/run/agenix/wireguard-private";

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
