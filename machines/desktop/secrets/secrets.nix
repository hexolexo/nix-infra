let
  hexolexo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn10kNU91QinvzDnJ/d6SMivvh+732dmcbHY4YurxGM hexolexo@hexolexo";
  hexolexo-pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYyTR6Qa5NMSlPfRkKKWauEtw6ykIYpgNDuHwLC0WA3 hexolexo-pc";
in {
  "nixosNATS.age".publicKeys = [hexolexo hexolexo-pc];
}
