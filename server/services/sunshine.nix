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
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false; # Server, not laptop
    open = false; # Quadros typically need proprietary
  };
  services.xserver = {
    enable = true;
    # WARN: Check your Quadro model - some need different BusID values
    deviceSection = ''
      Option "AllowEmptyInitialConfiguration"
    '';
    screenSection = ''
      Option "metamodes" "1920x1080_60 +0+0"
    '';
  };
}
