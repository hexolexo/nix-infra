{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../shared/home-manager/alacritty.nix
    ../shared/home-manager/fastfetch.nix
    ../shared/home-manager/fuzzel.nix
    ../shared/home-manager/nvim.nix
    ../shared/home-manager/waybar.nix
    ../shared/home-manager/terminal.nix
  ];
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "rebuild" (builtins.readFile ./../rebuild.sh))
    (pkgs.writeShellScriptBin "msh" (builtins.readFile ./../msh.sh))
    fzf
    highlight
  ];
}
