{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];

    displayManager = {
      lightdm.enable = true;
      autoLogin = {
        enable = true;
        user = "hexolexo";
      };
      defaultSession = "none+openbox";
    };

    windowManager.openbox.enable = true;

    screenSection = ''
      Option "metamodes" "nvidia-auto-select +0+0 { ForceCompositionPipeline = On, ForceFullCompositionPipeline = On }"
    '';
    # HACK: More aggressive virtual display forcing for headless Nvidia
    config = ''
      Section "Device"
        Identifier "Device0"
        Driver "nvidia"
        VendorName "NVIDIA Corporation"
        Option "AllowEmptyInitialConfiguration"
        Option "UseDisplayDevice" "none"
        Option "ConnectedMonitor" "DFP-0"
      EndSection

      Section "Screen"
        Identifier "Screen0"
        Device "Device0"
        DefaultDepth 24
        SubSection "Display"
          Depth 24
          Modes "1920x1080"
        EndSubSection
      EndSection
    '';
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    # nvidiaPersistenced = true; // Keeps GPU initialized without X
  };

  # Virtual audio sink for Sunshine to capture
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
