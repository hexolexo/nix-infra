{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = builtins.concatStringsSep "\n" [
      (builtins.readFile ./hyprland/sys.lua)
      (builtins.readFile ./hyprland/bindings.lua)
      (builtins.readFile ./hyprland/ux.lua)
    ];
  };
  home.file.".config/hypr/scripts" = {
    source = ../home-manager/hyprland/scripts;
    recursive = true;
  };
  home.file."Pictures/Backgrounds/Cloudsnight.jpg".source = ../Cloudsnight.jpg;
}
