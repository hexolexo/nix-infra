let
  hexolexo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn10kNU91QinvzDnJ/d6SMivvh+732dmcbHY4YurxGM hexolexo@hexolexo";

  vault = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDeNXsxz4yxwMkN59++dTACXxALG8jd68YJSjXqCveV vault";
in {
  "wireguard-hub-key.age".publicKeys = [hexolexo vault];
  "wireguard-hexolexo-key.age".publicKeys = [hexolexo];
}
