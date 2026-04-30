{
  pkgs,
  nix-minecraft,
  ...
}: {
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.skyblock = {
      enable = true;
      package = nix-minecraft.legacyPackages.${pkgs.system}.paperServers.paper-1_21_11;

      jvmOpts = ["-Xmx4G" "-Xms4G" "-XX:+UseG1GC"];

      serverProperties = {
        server-port = 25565;
        gamemode = 0;
        difficulty = 2;
        spawn-protection = 0;
        level-type = "flat"; # BentoBox overrides world gen anyway
        online-mode = true;
      };

      symlinks = {
        "plugins/BentoBox.jar" = pkgs.fetchurl {
          url = "https://github.com/BentoBoxWorld/BentoBox/releases/download/2.4.1/BentoBox-2.4.1.jar";
          sha256 = ""; # HACK: fill this in - run nix-prefetch-url on the URL to get it
        };
        "plugins/BSkyBlock.jar" = pkgs.fetchurl {
          url = "https://github.com/BentoBoxWorld/BSkyBlock/releases/latest/download/BSkyBlock.jar";
          sha256 = ""; # WARN: 'latest' in a URL will drift - pin to a specific release tag
        };
      };
    };
  };
}
