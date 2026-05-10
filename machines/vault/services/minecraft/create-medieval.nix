{
  pkgs,
  inputs,
  ...
}: let
  modpack = pkgs.fetchPackwizModpack {
    url = "http://10.0.0.1:3000/hexolexo/MMC5-mirror/raw/branch/main/pack.toml";
    packHash = "sha256-Gn/zTmT4d3JeC0j0l4TR0GYmxolIQIZieXA/RHDZB7Y=";
  };
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [inputs.nix-minecraft.overlays.default];
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.create-medieval = {
      enable = true;
      package = pkgs.neoforgeServers.neoforge-1_21_1;
      symlinks."mods" = "${modpack}/mods";

      jvmOpts = ["-Xmx12G" "-Xms12G" "-XX:+UseZGC" "-XX:+ZGenerational"];

      serverProperties = {
        server-port = 25569;
        gamemode = 0;
        difficulty = 2;
        white-list = true;
        max-players = 10;
      };

      whitelist = {
        hexolexo = "080aa9de-bcf6-4f3d-8e5d-a86f4977885a";
        ToshiiChu = "fd2b9565-56a6-45f4-a062-408633d9efc5";
        I_Am_Jam = "e84a7fab-0861-464d-81e3-ed8bda07795f";
        Circle_Yuh = "786069e6-8d7e-466a-9363-45a6734e6aff";
        Beco100 = "fea5630f-000f-4020-92ec-a15227730706";
        sticklegs900 = "ef354591-75cf-4a83-acd8-da5f2b36b8ac";
        Goodgamer1900 = "7236b3a1-8994-4908-a4f9-c75a5fb2fcf2";
        TemprMC = "8bc13718-746b-4bb3-b27e-2105ca34d8db";
      };
      symlinks."ops.json" = pkgs.writeText "ops.json" (builtins.toJSON [
        {
          uuid = "080aa9de-bcf6-4f3d-8e5d-a86f4977885a";
          name = "hexolexo";
          level = 4;
          bypassesPlayerLimit = false;
        }
      ]);
    };
  };
}
