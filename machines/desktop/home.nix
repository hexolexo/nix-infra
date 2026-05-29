{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../shared/home-manager/hyprland-laptop.nix
    ../shared/home-manager/anki.nix
    ../shared/home-manager/alacritty.nix
    ../shared/home-manager/ghostty.nix
    ../shared/home-manager/fastfetch.nix
    ../shared/home-manager/fuzzel.nix
    ../shared/home-manager/nvim.nix
    ../shared/home-manager/waybar.nix
    ../shared/home-manager/terminal.nix
  ];
  home.stateVersion = "25.11";
  services.easyeffects = {
    enable = true;
  };
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "rebuild" (builtins.readFile ../../scripts/rebuild.sh))

    (pkgs.writeShellScriptBin "nix-update" (builtins.readFile ../../scripts/nix-update.sh))
    (pkgs.writeShellScriptBin "msh" (builtins.readFile ../../scripts/msh.sh))
    (pkgs.writeShellScriptBin "dl" (builtins.readFile ../../scripts/dl.sh))
    (pkgs.writeShellScriptBin "update-playlist" (builtins.readFile ../../scripts/playlist_selector.sh))

    fzf
    highlight
  ];
  xdg.configFile."openvr/openvrpaths.vrpath" = {
    force = true;
    text = let
      steam = "${config.xdg.dataHome}/Steam";
    in
      builtins.toJSON {
        version = 1;
        jsonid = "vrpathreg";
        external_drivers = null;
        config = ["${steam}/config"];
        log = ["${steam}/logs"];
        runtime = ["${pkgs.xrizer}/lib/xrizer"];
      };
  };
}
