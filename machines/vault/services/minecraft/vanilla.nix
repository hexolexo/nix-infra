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
      files = {
        "plugins/NatsChatBridge.jar" = pkgs.stdenv.mkDerivation {
          name = "NatsChatBridge";
          src = ../../minecraftNATSChatMirroring-all.jar;
          phases = ["installPhase"];
          installPhase = "cp $src $out";
        };
      };

      serverProperties = {
        server-port = 25565;
        gamemode = 0;
        white-list = true;
        "enable-rcon" = true;
        "rcon.port" = 16260;
        "rcon.password" = "testingPassword";
        difficulty = 2;
        spawn-protection = 0;
        online-mode = true;
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [25565];
    interfaces."wg0".allowedTCPPorts = [16260];
  };
}
