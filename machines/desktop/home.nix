{
  config,
  pkgs,
  osConfig,
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
    force = true; # clobber whatever Steam wrote here
    text = builtins.toJSON {
      version = 1;
      jsonid = "vrpathreg";
      config = ["${config.xdg.dataHome}/Steam/config"];
      log = ["${config.xdg.dataHome}/Steam/logs"];
      runtime = ["${pkgs.opencomposite}/lib/opencomposite"];
      external_drivers = null;
    };
  };
}
