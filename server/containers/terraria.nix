{...}: {
  containers.terr = {
    autoStart = true;
    bindMounts = {
      "/var/lib/terraria" = {
        hostPath = "/var/lib/containers/terraria";
        isReadOnly = false;
      };
    };

    config = {
      config,
      lib,
      pkgs,
      ...
    }: let
      nix-tmodloader = builtins.getFlake "github:andOrlando/nix-tmodloader";
      unstable = import (builtins.getFlake "github:NixOS/nixpkgs/nixos-unstable") {
        config = {allowUnfree = true;};
      };
    in {
      environment.systemPackages = with pkgs; [
        tmux
      ];
      nix.settings.experimental-features = ["nix-command" "flakes"];
      system.stateVersion = "25.05";
      nixpkgs.config.allowUnfree = true;

      imports = [nix-tmodloader.nixosModules.tmodloader];
      nixpkgs.overlays = [
        nix-tmodloader.overlay
        (final: prev: {
          unstable = unstable;
          # Override tmodloader-server with updated version
          tmodloader-server = prev.tmodloader-server.overrideAttrs (oldAttrs: rec {
            version = "v2025.04.3.0";
            name = "tmodloader-${version}";
            src = pkgs.fetchurl {
              url = "https://github.com/tModLoader/tModLoader/releases/download/${version}/tModLoader.zip";
              sha256 = "0zf63r22yqi53y8ziciq8i6rhydkwmvxxpkdyn123nnkpnyprvvj"; # Replace with actual hash
            };
          });
          tmodloader-patched-server = final.tmodloader-server;
        })
      ];

      services = {
        tmodloader = {
          enable = true;
          servers.mycalamityserver = {
            enable = true;
            package = pkgs.tmodloader-patched-server;
            install = [
              #2562953970
              #2562997415
              #2565639705
              #2670628346
              #2816557864
              #2822950837
              #2824688266
              #2979448082
              #3222493606
              #3499210528
              #2562968836
              #2563309347
              #2619954303
              #2785100219
              #2817496179
              #2824688072
              2908170107
              2995193002
              3269610671
            ];
            autoStart = true;
          };
        };
      };

      networking.firewall.allowedTCPPorts = [7777];

      # Ensure terraria directory has correct permissions
      systemd.tmpfiles.rules = [
        "d /var/lib/terraria 755 terraria terraria -"
      ];
    };
  };

  # Host firewall - forward port to container
  networking.firewall.allowedTCPPorts = [7777];
}
