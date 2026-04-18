let
  hexolexo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn10kNU91QinvzDnJ/d6SMivvh+732dmcbHY4YurxGM hexolexo@hexolexo";

  vault = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHE7EZaeHn/1nblIGTImO3LHt1SZloWJg29gfJ2jqi+I vault";
in {
  "wireguard-hub-key.age".publicKeys = [hexolexo vault];
  "wireguard-hexolexo-key.age".publicKeys = [hexolexo];
}
