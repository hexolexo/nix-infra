{...}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "/data/jellyfin"; # state, config, metadata
  };
  users.users.jellyfin = {
    extraGroups = ["copyparty"];
  };
}
