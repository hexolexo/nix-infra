{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../shared/home-manager/fastfetch.nix
    ../shared/home-manager/nvim.nix
    ../shared/home-manager/terminal.nix
  ];
  home.stateVersion = "25.11";
  home.enableNixpkgsReleaseCheck = false; # Due to nixvim
}
