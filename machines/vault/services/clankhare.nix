{
  inputs,
  config,
  ...
}: {
  imports = [inputs.agenix.nixosModules.default];

  # Decrypt the secret
  age.secrets.clankhare-env = {
    file = ../secrets/clankhare-env.age;
    mode = "0444";
  };

  services.clankhare = {
    enable = true;
    configFile = config.age.secrets.clankhare-env.path;
  };
}
