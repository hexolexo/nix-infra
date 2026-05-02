{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nur.url = "github:nix-community/NUR";
    secrets.url = "path:/home/hexolexo/Programming/sysadmin/secrets";

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    deploy-rs.url = "github:serokell/deploy-rs";
  };
  outputs = {
    nixpkgs-stable,
    nixpkgs-unstable,
    home-manager-stable,
    home-manager-unstable,
    secrets,
    agenix,
    self,
    disko,
    nur,
    copyparty,
    nixvim,
    deploy-rs,
    ...
  } @ inputs: {
    nixosConfigurations = {
      hexolexo = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit secrets;
        };
        modules = [
          ./desktop/configuration.nix
          ./desktop/networking.nix
          agenix.nixosModules.default
          home-manager-unstable.nixosModules.home-manager
          {
            home-manager.sharedModules = [
              nixvim.homeModules.nixvim
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hexolexo = import ./desktop/home.nix;
          }
        ];
      };

      vault = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit secrets inputs;
        };
        modules = [
          disko.nixosModules.disko
          ./server/configuration.nix
          ./server/disko.nix
          copyparty.nixosModules.default
          agenix.nixosModules.default
          ({pkgs, ...}: {
            nixpkgs.overlays = [copyparty.overlays.default];
          })
          home-manager-stable.nixosModules.home-manager
          {
            home-manager.sharedModules = [
              nixvim.homeModules.nixvim
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hexolexo = import ./server/home.nix;
          }
        ];
      };
      bootstrap = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [./bootstrap/bootstrap.nix];
      };
    };

    deploy.nodes.vault = {
      hostname = "server";
      remoteBuild = true;
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vault;
      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    packages.x86_64-linux.bootstrap =
      self.nixosConfigurations.bootstrap.config.system.build.isoImage;
    devShells.x86_64-linux.default = nixpkgs-unstable.legacyPackages.x86_64-linux.mkShell {
      packages = [
        deploy-rs.packages.x86_64-linux.default
        agenix.packages.x86_64-linux.default
        nixpkgs-unstable.legacyPackages.x86_64-linux.nixos-anywhere
      ];
    };
  };
}
