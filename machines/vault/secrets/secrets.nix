let
  hexolexo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn10kNU91QinvzDnJ/d6SMivvh+732dmcbHY4YurxGM hexolexo@hexolexo";
  hexolexo-pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgvxrYf8zSBZ+JU8L7Q+dCkcB+695JOYM8o1qPLoLDo hexolexo@hexolexo-pc";
  vault = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICj7A6xfoX2gLyqM53wACqW+siNuyiLLaBanExtTifIL vault";
in {
  "nixosNATS.age".publicKeys = [hexolexo hexolexo-pc vault];
  "wireguard-hub-key.age".publicKeys = [hexolexo vault];
  "wireguard-hexolexo-key.age".publicKeys = [hexolexo];
  "radicle-key.age".publicKeys = [vault hexolexo];
  "libvirtNATS.age".publicKeys = [vault hexolexo];
  "wireguardNATS.age".publicKeys = [vault hexolexo];
  "clankhare-env.age".publicKeys = [vault hexolexo];
}
