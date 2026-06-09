{pkgs, ...}: {
  services.ollama = {
    enable = true;
    host = "10.0.0.8";
    package = pkgs.ollama-rocm;
    # WARN: without this ollama-rocm may pick the iGPU (card0/Raphael)
    # over the 9070 (card1) - same trap we just fell into with llama.cpp
    environmentVariables = {
      HIP_VISIBLE_DEVICES = "1"; # verify this is still the 9070 after reboot
      HSA_OVERRIDE_GFX_VERSION = "12.0.1";
    };
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [11434];
}
