{
  pkgs,
  inputs,
  ...
}: {
  systemd.services.prominence2 = {
    description = "Prominence II Minecraft Server";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];

    # One-shot bootstrap script — run manually after first deploy, not on every start
    # HACK: server directory is fully mutable, no Nix tracking of mod state
    serviceConfig = {
      User = "minecraft";
      WorkingDirectory = "/srv/minecraft/prominence2";
      ExecStart = "${pkgs.jdk21}/bin/java -Xms10G -Xmx10G -XX:+UseG1GC -jar fabric-server-launch.jar nogui";
      TimeoutStopSec = "60";
      Restart = "on-failure";
      RestartSec = "10s";
    };

    networking.firewall.allowedTCPPorts = [25565];
  };
}
