{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [inputs.agenix.nixosModules.default];

  # Decrypt the secret
  age.secrets.clankhare-env = {
    file = ../../secrets/clankhare-env.age;
    mode = "0444";
  };

  systemd.services.clankhare = {
    description = "Clankhare Discord Bot";
    after = ["network-online.target"];
    wantedBy = ["multi-user.target"];

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
