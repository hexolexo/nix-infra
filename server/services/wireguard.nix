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
          publicKey = "SZDybQeTfr8A9Ae43c6orHNhkogTusdMLnyqSAg/u0U=";
          allowedIPs = ["10.0.0.3/32"]; # Amaboutta
          persistentKeepalive = 25;
        }
        {
          publicKey = "v54b/A7ynLrcXBMcgJkf6vgzJgra8Z3BkaFHMy1RMWk=";
          allowedIPs = ["10.0.0.4/32"]; # death
          persistentKeepalive = 25;
        }
        {
          publicKey = "BE4SyGzajYqOZ+1x04KveR87QLa6kGF/FEH3w76lAAI=";
          allowedIPs = ["10.0.0.5/32"]; # tempr
          persistentKeepalive = 25;
        }
        {
          publicKey = "SSXDHlSHH63rYa3KC4JskkO2sesb/dxO0hFUq54GTFU=";
          allowedIPs = ["10.0.0.6/32"]; # tempr
          persistentKeepalive = 25;
        }
        {
          publicKey = "L8SP4nzgB6ywOxEhp8n4O9/J70AGx4CFT3QLDF5NJXs=";
          allowedIPs = ["10.0.0.10/32"]; # CI builder
          persistentKeepalive = 25;
        }
        {
          publicKey = "UE1O3n+6/yNxqwdjirvDeXTHD2QewhVZO6QxdF+hs0Q=";
          allowedIPs = ["10.0.0.11/32"]; # quest
          persistentKeepalive = 25;
        }
      ];
    };
  };
  networking.firewall.allowedUDPPorts = [51820];
}
