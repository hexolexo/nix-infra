let
  hexolexo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn10kNU91QinvzDnJ/d6SMivvh+732dmcbHY4YurxGM hexolexo@hexolexo";
  vault = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHXQaflaHfzVh5sQl98Dy03A3rX36E/j1kReA7kxDwE root@nixos";
in {
  "clankhare-env.age".publicKeys = [vault hexolexo];
}
