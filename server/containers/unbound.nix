{...}: {
  containers.unbound = {
    #
    autoStart = true;
    privateNetwork = false;
    config = {
      pkgs,
      lib,
      ...
    }: {
      services.unbound = {
        enable = true;
        settings = {
          server = {
            interface = ["10.0.0.1" "127.0.0.1" "::1"];
            access-control = [
              "127.0.0.0/8 allow"
              "::1 allow"
              "10.0.0.0/24 allow"
            ];
            auto-trust-anchor-file = "/var/lib/unbound/root.key";

            hide-identity = true;
            hide-version = true;

            prefetch = true;
            num-threads = 2;
          };
          remote-control = {
            control-enable = true;
          };
        };
      };
      boot.isContainer = true;

      system.stateVersion = "25.05";
    };
  };
}
