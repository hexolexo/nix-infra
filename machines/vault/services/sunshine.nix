{...}: {
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # needed for virtual display/input capture
  };
  networking.firewall = {
    allowedTCPPorts = [47984 47989 47990 48010];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48000;
      }
    ];
  };
}
