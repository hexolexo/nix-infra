{pkgs, ...}: {
  services.ollama = {
    enable = true;
    host = "10.0.0.8";
    package = pkgs.ollama-vulkan;
    rocmOverrideGfx = "12.0.1";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1201";
      OLLAMA_VULKAN = "1";
    };
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [11434];
}
