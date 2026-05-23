{
  pkgs,
  inputs,
  ...
}: let
  # 1. Fetch the Modrinth pack as a standalone derivation
  # It strips client mods and prepares server-side configurations natively
  prominenceModpack = pkgs.fetchModrinthModpack {
    id = "prominence-2-rpg";
    url = "https://cdn.modrinth.com/data/EGs3lC8D/versions/9r2hKvJH/Prominence%20II%20Hasturian%20Era%203.9.27.mrpack?mr_download_reason=standalone&mr_game_version=1.20.1&mr_loader=fabric";
    version = "3.0.7";
    packHash = "sha256-33BPbJpidKgjqQUdzddH6WmfXoSgaR0LOVyNUgg26B0="; # Will error out with the true hash on first run
  };
in {
  nixpkgs.config.allowUnfree = true;

  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  nixpkgs.overlays = [
    inputs.nix-minecraft.overlay
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/var/lib/minecraft";

    servers.prominence = {
      enable = true;

      # 2. Assign the actual Fabric Loader engine to run the pack
      package = pkgs.fabricServers.fabric-1_20_1.override {
        loaderVersion = "0.18.4";
      };

      # 3. Mount the filtered modpack contents dynamically into the runtime directory
      # This strips client-side configs/mods and preserves server-side writability
      symlinks = {
        "mods" = "${prominenceModpack}/mods";
        "config" = "${prominenceModpack}/config";
      };

      openFirewall = true;

      serverProperties = {
        server-port = 25565;
        motd = "Prominence II RPG - Managed Declaratively by NixOS";
        difficulty = "hard";
        "query.port" = 25565;
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
