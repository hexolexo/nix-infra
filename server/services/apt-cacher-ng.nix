{pkgs, ...}: {
  environment.etc."apt-cacher-ng/acng.conf".text = ''
    CacheDir: /var/cache/apt-cacher-ng
    LogDir: /var/log/apt-cacher-ng
    Port: 3142
    BindAddress: 0.0.0.0
    Remap-debrep: file:deb_mirror*.gz /debian ; file:backends_debian https
    Remap-uburep: file:ubuntu_mirrors /ubuntu ; file:backends_ubuntu https
    ReportPage: acng-report.html
    VerboseLog: 1
  '';
  systemd.services.apt-cacher-ng = {
    description = "Apt-Cacher NG";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];

    serviceConfig = {
      ExecStart = "${pkgs.apt-cacher-ng}/bin/apt-cacher-ng -c /etc/apt-cacher-ng ForeGround=1"; # directory, not file
      StateDirectory = "apt-cacher-ng";
      CacheDirectory = "apt-cacher-ng";
      LogsDirectory = "apt-cacher-ng";
      User = "apt-cacher-ng";
      Group = "apt-cacher-ng";
      Restart = "on-failure";
    };
  };
  environment.systemPackages = [pkgs.apt-cacher-ng];

  users.users.apt-cacher-ng = {
    isSystemUser = true;
    group = "apt-cacher-ng";
  };

  users.groups.apt-cacher-ng = {};

  networking.firewall.allowedTCPPorts = [3142];
}
