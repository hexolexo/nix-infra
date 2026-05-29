{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./gamedev.nix
    ./fanCtrl.nix
    ../shared/common.nix
  ];

  networking.hostName = "hexolexo";

  boot.kernelParams = ["amd_pstate=active"];
  boot.kernelModules = ["ryzen_smu"];

  services.logind.settings.Login = {
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitch = "ignore";
  };

  services.fanControl = {
    enable = true;
    allowedUsers = ["hexolexo"];
    quietDuty = 40;
    maxDuty = 100;
  };

  services.displayManager.cosmic-greeter.enable = true;

  system.stateVersion = "25.05";
}
