{config, ...}: {
  age.secrets.radicle-key = {
    file = ../../secrets/radicle-key.age;
    mode = "0400";
  };
  networking.firewall.allowedTCPPorts = [8776 18080]; # God I hope this works
  containers.radicle = {
    autoStart = true;
    privateNetwork = false;
    bindMounts.data = {
      hostPath = "/data/radicle";
      mountPoint = "/var/lib/radicle";
      isReadOnly = false;
    };
    bindMounts.radicle-key = {
      hostPath = config.age.secrets.radicle-key.path;
      mountPoint = "/run/agenix/radicle-key";
      isReadOnly = true;
    };
    config = {pkgs, ...}: {
      services.nginx = {
        enable = true;
        virtualHosts."_" = {
          listen = [
            {
              addr = "10.0.0.1";
              port = 18080;
            }
          ];
          root = "${pkgs.radicle-explorer}";
          locations."/api".proxyPass = "http://127.0.0.1:8080";
        };
      };
      services.radicle = {
        enable = true;
        checkConfig = false; #  HACK: validator is broken in current nixpkgs
        privateKeyFile = "/run/agenix/radicle-key";
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFvTTfJAw5sHWldnVbnmotGSJ9bNEDQZWyWxgRO0EouB radicle";
        node.openFirewall = true;
        node.listenAddress = "[::0]";
        httpd = {
          enable = true;
          #listenAddress = "10.0.0.1";
        };
        settings = {
          node = {
            alias = "vault";
            externalAddresses = ["vault:8776"];
            seedingPolicy = {
              default = "allow";
              scope = "all";
            };
          };
        };
      };
      boot.isContainer = true;
      system.stateVersion = "25.11";
    };
  };
}
