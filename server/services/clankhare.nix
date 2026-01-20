{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [inputs.agenix.nixosModules.default];

  age.secrets.clankhare-env = {
    file = ../clankhare-env.age;
    mode = "0444";
  };

  systemd.services.clankhare = {
    description = "Clankhare Discord Bot";
    after = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      ExecStart = "${inputs.clankhare.packages.${pkgs.system}.default}/bin/Clankhare";

      EnvironmentFile = config.age.secrets.clankhare-env.path;

      Restart = "always";
      RestartSec = "5s";
      DynamicUser = true;

      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
    };
  };
}
