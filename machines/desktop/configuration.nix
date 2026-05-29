{
  pkgs,
  nixos-cachyos-kernel,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../shared/common.nix
    ./networking.nix
    ./ollama.nix
  ];

  networking = {
    hostName = "hexolexo-pc";
    networkmanager.enable = true;
    networkmanager.wifi.powersave = false;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.openssh.enable = true;

  #nix.settings = {
  #substituters = ["https://drakon64-nixos-cachyos-kernel.cachix.org"];
  #trusted-public-keys = ["drakon64-nixos-cachyos-kernel.cachix.org-1:J3gjZ9N6S05pyLA/P0M5y7jXpSxO/i0rshrieQJi5D0="];
  #};

  #boot.kernelPackages = pkgs.cachyosKernels."linuxPackages-cachyos-latest-zen4"; # not being cached for whatever reason
  boot.initrd.kernelModules = ["amdgpu"];

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    zenity # runtime dep for ALVR dialogs; not declared in the package
  ];

  programs.alvr = {
    enable = true;
    openFirewall = true;
  };

  system.stateVersion = "25.11";
}
