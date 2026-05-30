{config, ...}: {
  services.conduit.nixos-agent = {
    enable = true;
    natsURL = "nats://10.0.0.1:4222";
    nkeySeedFile = "/home/hexolexo/.secrets/testkey"; #  TODO: replace this for an agenix key
    flakePath = "git+http://10.0.0.1:3000/hexolexo/nix-infra.git";
    flakeTarget = "hexolexo-pc";
  };
}
