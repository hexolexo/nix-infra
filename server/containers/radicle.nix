{config, ...}: {
  age.secrets.radicle-key = {
    file = ../../secrets/radicle-key.age;
    mode = "0400";
  };
  networking.firewall.allowedTCPPorts = [8776]; # God I hope this works
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
    config = {...}: {
      services.radicle = {
        enable = true;
        privateKeyFile = "/run/agenix/radicle-key";
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFvTTfJAw5sHWldnVbnmotGSJ9bNEDQZWyWxgRO0EouB radicle";
        node.openFirewall = true;
        node.listenAddress = "[::0]";
        httpd.enable = true;
      };
      boot.isContainer = true;
      system.stateVersion = "25.11";
    };
  };
}
