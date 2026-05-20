{...}: {
  services.jellyfin = {
    enable = true;
    openFirewall = false;
    dataDir = "/data/jellyfin"; # state, config, metadata
  };
  users.users.jellyfin = {
    extraGroups = ["copyparty"];
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [8096];
}
