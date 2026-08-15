{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.llama-cpp.override {vulkanSupport = true;})
  ];

  # Mesa RADV driver, needed for Vulkan on RDNA4
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # only if you need 32-bit Vulkan clients
  };

  boot.initrd.kernelModules = ["amdgpu"];
}
