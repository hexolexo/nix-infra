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

    # HACK: Forces Nvidia to create virtual displays headless
    deviceSection = ''
      Option "AllowEmptyInitialConfiguration"
      Option "UseDisplayDevice" "none"
      Option "ConnectedMonitor" "DFP-0"
    '';

    screenSection = ''
      Option "metamodes" "1920x1080_60 +0+0"
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
