let
  hexolexo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn10kNU91QinvzDnJ/d6SMivvh+732dmcbHY4YurxGM hexolexo@hexolexo";
  hexolexo-pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP4nWGy1WK0ek+/y2TI9T++CHfigMLFjCxPWmYKaTnMc hexolexo@hexolexo-pc";
  vault = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICj7A6xfoX2gLyqM53wACqW+siNuyiLLaBanExtTifIL vault";
in {
  "nixosNATS.age".publicKeys = [hexolexo hexolexo-pc vault];
  "wireguard-hub-key.age".publicKeys = [hexolexo hexolexo-pc vault];
  "wireguard-hexolexo-key.age".publicKeys = [hexolexo hexolexo-pc];
  "radicle-key.age".publicKeys = [vault hexolexo hexolexo-pc];
  "libvirtNATS.age".publicKeys = [vault hexolexo hexolexo-pc];
  "wireguardNATS.age".publicKeys = [vault hexolexo hexolexo-pc];
  "clankhare-env.age".publicKeys = [vault hexolexo hexolexo-pc];
}
