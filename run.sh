nix run github:nix-community/nixos-anywhere -- \
  --flake .#hexolexo-pc \
  --target-host root@localhost \
  --build-on local
