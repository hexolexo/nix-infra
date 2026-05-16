{inputs, ...}: {
  systemd.tmpfiles.rules = [
    "d /data/copyparty 0777 copyparty copyparty -"
  ];
  networking.firewall.allowedTCPPorts = [3210 3211];
  imports = [inputs.copyparty.nixosModules.default];
  nixpkgs.overlays = [inputs.copyparty.overlays.default];
  services.copyparty = {
    enable = true;
    user = "copyparty";
    group = "copyparty";
    # see `copyparty --help` for available options
    settings = {
      i = [
        "127.0.0.1"
        "10.0.0.1"
      ];
      p = [3210 3211];
      no-reload = true;
      ignored-flag = false;
    };

    # create a volume
    volumes = {
      # create a volume at "/" (the webroot), which will
      "/" = {
        path = "/data/copyparty";
        access = {
          rw = ["*"];
          d = ["*"];
        };
        flags = {
          # "fk" enables filekeys (necessary for upget permission) (4 chars long)
          fk = 4;
          # scan for new files every 60sec
          scan = 60;
          # volflag "e2d" enables the uploads database
          e2d = true;
          # "d2t" disables multimedia parsers (in case the uploads are malicious)
          d2t = true;
          # skips hashing file contents if path matches *.iso
          nohash = "\.iso$";
          chmod_d = "0750";
        };
      };
    };
    # you may increase the open file limit for the process
    openFilesLimit = 8192;
  };

  networking.firewall.interfaces."wg0".allowedTCPPorts = [3210 3211];
}
