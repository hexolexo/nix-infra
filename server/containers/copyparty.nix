{...}: {
  containers.copyparty = {
    autoStart = true;
    privateNetwork = false;
    bindMounts.content = {
      hostPath = "/var/lib/containers/copyparty-share";
      mountPoint = "/svr/copyparty";
      isReadOnly = false;
    };

    config = {
      pkgs,
      lib,
      ...
    }: {
      users.groups.copyparty = {};
      users.users.copyparty = {
        isNormalUser = true;
        group = "copyparty";
        home = "/home/copyparty";
        createHome = true;
      };
      nixpkgs.overlays = [copyparty.overlays.default];
      services.copyparty = {
        enable = true;
        user = "copyparty";
        group = "copyparty";
        # directly maps to values in the [global] section of the copyparty config.
        # see `copyparty --help` for available options
        settings = {
          i = "10.0.0.1";
          p = [3210 3211];
          no-reload = true;
          ignored-flag = false;
        };

        # create a volume
        volumes = {
          # create a volume at "/" (the webroot), which will
          "/" = {
            # share the contents of "/srv/copyparty"
            path = "/srv/copyparty";
            # see `copyparty --help-accounts` for available options
            access = {
              # everyone gets rw-access
              rw = ["*"];
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
            };
          };
        };
        # you may increase the open file limit for the process
        openFilesLimit = 8192;
      };

      boot.isContainer = true;

      system.stateVersion = "25.11";
    };
  };
}
