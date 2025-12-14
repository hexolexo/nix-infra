{pkgs, ...}: let
  global = import ./../global.nix;
in {
  # Soft Serve Git server
  services.soft-serve = {
    enable = true;
    settings = {
      name = "hexolexo's repos";
      description = "hexolexo's local repos";
      ssh.public_url = "ssh://localgit";
      host = "10.0.0.1";
      port = 23231;
      initial_admin_keys = global.authorisedKeys;
    };
  };

  # Open firewall ports for local access
  networking.firewall = {
    allowedTCPPorts = [
      23231 # Soft Serve Git SSH
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    soft-serve
    docker-compose
    git
    curl
  ];

  # Git user for soft-serve
  users.users.git = {
    isSystemUser = true;
    home = "/var/lib/soft-serve";
    group = "git";
    createHome = true;
  };
  users.groups.git = {};

  systemd.services.soft-serve = {
    serviceConfig = {
      DynamicUser = pkgs.lib.mkForce false;
      User = "git";
      Group = "git";
    };
  };
}
