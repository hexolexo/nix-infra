{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nur.url = "github:nix-community/NUR";
    secrets.url = "git+ssh://git@localgit/secrets.git";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    clankhare.url = "github:hexolexo/clankhare";

    #nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    deploy-rs.url = "github:serokell/deploy-rs";
  };
  outputs = {
    nixpkgs-stable,
    nixpkgs-unstable,
    home-manager-stable,
    home-manager-unstable,
    secrets,
    zen-browser,
    agenix,
    clankhare,
    self,
    nur,
    #nix-minecraft,
    nixvim,
    deploy-rs,
    ...
  } @ inputs: {
    nixosConfigurations.hexolexo = nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit secrets zen-browser;
      };
      modules = [
        ./desktop/configuration.nix
        ./desktop/networking.nix
        agenix.nixosModules.default
        home-manager-unstable.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            (final: prev: {
              nur = import nur {
                nurpkgs = prev;
                pkgs = prev;
              };
              zen-browser = zen-browser.packages.x86_64-linux.default;
            })
          ];
        }

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

    nixosConfigurations.vault = nixpkgs-stable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit secrets clankhare inputs;
      };
      modules = [
        ./server/configuration.nix
        home-manager-stable.nixosModules.home-manager
        #nix-minecraft.nixosModules.minecraft-servers
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

    deploy.nodes.vault = {
      hostname = "server";
      remoteBuild = true;
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vault;
      };
    };

    devShells.x86_64-linux.default = nixpkgs-unstable.legacyPackages.x86_64-linux.mkShell {
      packages = [deploy-rs.packages.x86_64-linux.default];
    };
  };
}
