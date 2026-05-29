{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = builtins.concatStringsSep "\n" [
      (builtins.readFile ./hyprland/sys.conf)

      (builtins.readFile ./hyprland/bindings.conf)
      (builtins.readFile ./hyprland/ux.conf)
    ];
  };
  home.file.".config/hypr/scripts" = {
    source = ../home-manager/hyprland/scripts;
    recursive = true;
  };
  home.file."Pictures/Backgrounds/Cloudsnight.jpg".source = ../Cloudsnight.jpg;
}
