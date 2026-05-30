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
    ./audio.nix
    ./virtualisation.nix
    ./conduit.nix
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

  boot.initrd.kernelModules = ["amdgpu"];

  programs.steam.enable = true;

  services.xserver.videoDrivers = ["amdgpu"];

  services.wivrn = {
    enable = true;
    openFirewall = true; # pokes UDP hole for streaming
  };

  environment.systemPackages = with pkgs; [
    wayvr
  ];

  nix.settings.substituters = ["https://attic.xuyh0120.win/lantian"];
  nix.settings.trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.cachyosKernels.linux-cachyos-latest-zen4;

  programs.alvr = {
    enable = true;
    openFirewall = true;
  };

  system.stateVersion = "25.11";
}
