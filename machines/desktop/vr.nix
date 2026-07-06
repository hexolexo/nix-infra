{pkgs, ...}: {
  systemd.user.services.wivrn.environment = {
    XRT_COMPOSITOR_COMPUTE = "1";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    XRT_COMPOSITOR_FORCE_WAIT_FOR_PRESENT = "0";
  };

  systemd.user.services.wivrn.serviceConfig = {
    AmbientCapabilities = "CAP_SYS_NICE";
    CapabilityBoundingSet = "CAP_SYS_NICE";
  };

  services.xserver.videoDrivers = ["amdgpu"];

  services.wivrn = {
    enable = true;
    openFirewall = true; # pokes UDP hole for streaming
  };

  environment.systemPackages = with pkgs; [
    # VR
    android-tools
    appimage-run
    fuse
    protontricks
    xrizer
    wayvr
  ];
}
