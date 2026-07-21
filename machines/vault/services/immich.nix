{...}: {
  services.immich = {
    enable = true;
    openFirewall = true;
    port = 2283;
    host = "10.0.0.1";
  };
}
