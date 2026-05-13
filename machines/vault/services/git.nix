{pkgs, ...}: let
  forgejoPort = 3000;
  forgejoSSHPort = 2222;
in {
  systemd.tmpfiles.rules = [
    "d /data 0755 root root -"
    "d /data/forgejo 0750 forgejo forgejo -"
  ];

  services.forgejo = {
    enable = true;
    package = pkgs.forgejo-lts;
    stateDir = "/data/forgejo";
    lfs.enable = true;
    database.type = "sqlite3";
    settings = {
      F3.ENABLED = false;
      server = {
        DOMAIN = "10.0.0.1";
        ROOT_URL = "http://10.0.0.1:${toString forgejoPort}/";
        HTTP_ADDR = "10.0.0.1";
        HTTP_PORT = forgejoPort;
        START_SSH_SERVER = true;
        SSH_LISTEN_HOST = "10.0.0.1";
        SSH_PORT = forgejoSSHPort;
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
      storage = {
        PATH = "/data/forgejo/storage";
      };

      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };

  #  WARN: tokenFile must exist before this service starts
  # grab token from Site Administration > Actions > Runners > Create new Runner
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = false;
      name = "hexolexo-runner";
      url = "http://10.0.0.1:${toString forgejoPort}";
      tokenFile = "/run/secrets/forgejo-runner-token";
      labels = [
        "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:full-22.04"
      ];
    };
  };
  systemd.services.gitea-runner-default = {
    after = ["forgejo.service"];
    requires = ["forgejo.service"];
    serviceConfig = {
      CPUQuota = "2000%";
      MemoryMax = "16G";
    };
  };
  networking.firewall.allowedTCPPorts = [
    forgejoPort
    forgejoSSHPort
  ];

  environment.systemPackages = with pkgs; [
    forgejo-lts
    git
    curl
  ];
}
