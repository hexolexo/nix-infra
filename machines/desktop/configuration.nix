{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../shared/common.nix
    # No fanCtrl, no lid switch, no AMD pstate (check if your desktop is also AMD)
  ];

  networking = {
    hostName = "hexolexo-pc";
    networkmanager.enable = true;
    networkmanager.wifi.powersave = false;
  };

  # WARN: plasma6 conflicts with hyprland being the session — pick one or gate
  # behind a home-manager profile. Currently common.nix enables hyprland globally.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.openssh.enable = true;

  system.stateVersion = "25.11";
}
