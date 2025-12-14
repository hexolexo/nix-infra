{lib, ...}: let
  peersFile = builtins.readFile ./peers.txt;

  # Parse a line with the format: "hexolexo 2 vWCeMXG... keepalive"
  parsePeer = line: let
    parts = lib.splitString " " line;
    name = builtins.elemAt parts 0;
    ip = builtins.elemAt parts 1;
    key = builtins.elemAt parts 2;
    hasKeepalive = builtins.length parts > 3 && builtins.elemAt parts 3 == "keepalive";
  in {
    inherit name ip key;
    ka = hasKeepalive;
  };

  peerLines = lib.filter (s: s != "") (lib.splitString "\n" peersFile);
  peers = map parsePeer peerLines;

  # Convert to wireguard peer format
  mkPeer = p:
    {
      publicKey = p.key;
      allowedIPs = ["10.0.0.${p.ip}/32"];
    }
    // lib.optionalAttrs p.ka {
      persistentKeepalive = 25;
    };
in {
  networking.wireguard.interfaces.wg0 = {
    privateKeyFile = "/etc/wireguard/private";
    listenPort = 51820;
    ips = ["10.0.0.1/24"];
    peers = map mkPeer peers;
  };

  networking.firewall.allowedUDPPorts = [51820];
}
