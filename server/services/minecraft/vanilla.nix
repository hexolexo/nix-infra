{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.skyblock = {
      enable = true;
      package = inputs.nix-minecraft.legacyPackages.${pkgs.system}.paperServers.paper-1_21_11;

      jvmOpts = ["-Xmx4G" "-Xms4G" "-XX:+UseG1GC"];

      serverProperties = {
        server-port = 25565;
        gamemode = 0;
        difficulty = 2;
        spawn-protection = 0;
        online-mode = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [25565];
}
