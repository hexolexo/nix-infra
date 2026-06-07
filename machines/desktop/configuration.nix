{pkgs, ...}: let
  global = import ../vault/global.nix;
in {
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
    XRT_COMPOSITOR_COMPUTE = "1";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    XRT_COMPOSITOR_FORCE_WAIT_FOR_PRESENT = "0";
  };
  systemd.user.services.wivrn.serviceConfig = {
    AmbientCapabilities = "CAP_SYS_NICE";
    CapabilityBoundingSet = "CAP_SYS_NICE";
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.openssh.enable = true;
  users.users = {
    hexolexo.openssh.authorizedKeys.keys = global.laptopKey;
    root.openssh.authorizedKeys.keys = global.laptopKey;
  };

  boot.initrd.kernelModules = ["amdgpu"];

  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
  ];

  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin]; # if you use this, keep it

    # HACK: extraProfile doesn't reliably propagate through bwrap into
    # pressure-vessel; setting it here does
    package = pkgs.steam.override {
      extraEnv = {
        PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = "1";
      };
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
