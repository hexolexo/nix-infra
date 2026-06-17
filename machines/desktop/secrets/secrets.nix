let
  hexolexo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn10kNU91QinvzDnJ/d6SMivvh+732dmcbHY4YurxGM hexolexo@hexolexo";
  hexolexo-pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsyN3hjZZM3V+n87LCuuHJle5Wo236Mdkybvp+9DW3Z hexolexo-pc";
in {
  "nixosNATS.age".publicKeys = [hexolexo hexolexo-pc];
}
