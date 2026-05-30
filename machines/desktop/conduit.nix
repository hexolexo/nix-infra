{config, ...}: {
  age.secrets.conduit-nixos = {
    file = ./secrets/nixosNATS.age;
    owner = "root";
    mode = "0400";
  };

  services.conduit.nixos-agent = {
    enable = true;
    natsURL = "nats://10.0.0.1:4222";
    nkeySeedFile = config.age.secrets.conduit-nixos.path;
    flakePath = "git+http://10.0.0.1:3000/hexolexo/nix-infra.git";
    flakeTarget = "hexolexo-pc";
  };
}
