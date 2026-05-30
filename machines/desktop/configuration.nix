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
  systemd.user.services.wivrn.environment = {
    XRT_COMPOSITOR_COMPUTE = "1"; # force GPU-side async reprojection
  };
  systemd.user.services.wivrn.serviceConfig = {
    AmbientCapabilities = "CAP_SYS_NICE";
    CapabilityBoundingSet = "CAP_SYS_NICE";
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.openssh.enable = true;

  boot.initrd.kernelModules = ["amdgpu"];

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraProfile = ''
        # punch WiVRn socket through pressure-vessel sandbox for all VR games
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
        unset TZ  # fixes VRChat timezone issues, harmless otherwise
      '';
    };
  };

  services.xserver.videoDrivers = ["amdgpu"];

  services.wivrn = {
    enable = true;
    openFirewall = true; # pokes UDP hole for streaming
  };
  services.hardware.openrgb.enable = true;

  environment.systemPackages = with pkgs; [
    monado-vulkan-layers
    godot
    mangohud
    vulkan-tools
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
