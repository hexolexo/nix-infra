{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../shared/common.nix
    ./networking.nix
  ];

  networking = {
    hostName = "hexolexo-pc";
    networkmanager.enable = true;
    networkmanager.wifi.powersave = false;
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.openssh.enable = true;

  nix.settings = {
    substituters = ["https://drakon64-nixos-cachyos-kernel.cachix.org"];
    trusted-public-keys = ["drakon64-nixos-cachyos-kernel.cachix.org-1:J3gjZ9N6S05pyLA/P0M5y7jXpSxO/i0rshrieQJi5D0="];
  };

  #boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linuxPackages_cachyos;

  # ALVR
  programs.alvr.enable = true;

  # PipeWire virtual mic for Mumble effects routing
  services.pipewire.extraConfig.pipewire."virtual-mic" = {
    "context.modules" = [
      {
        name = "libpipewire-module-adapter";
        args = {
          "factory.name" = "support.null-audio-sink";
          "node.name" = "mumble-to-effects";
          "node.description" = "Mumble Virtual Input";
          "media.class" = "Audio/Sink";
          "object.linger" = true;
          "audio.channels" = 2;
          "audio.position" = ["FL" "FR"];
          "node.dont-reconnect" = true;
          "stream.dont-remix" = true;
          "node.passive" = true;
        };
      }
    ];
  };

  system.stateVersion = "25.11";
}
