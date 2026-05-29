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
    substituters = [
      "https://nix-cachyos-kernel.cachix.org"
      # WARN: Second cache is the author's personal Hydra — may go down
      "https://xddxdd.cachix.org"
    ];
    trusted-public-keys = [
      "nix-cachyos-kernel.cachix.org-1:cFPpFAX4GFpRDnGkQXCTbLvJyAZBCQeKzqWBBqWwROY="
      "xddxdd.cachix.org-1:MzATbxHP1k0/hFBDrqGfpXW98Ls22MzMjkFcUzT8HqE="
    ];
  };

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
