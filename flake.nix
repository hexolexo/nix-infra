{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    secrets.url = "git+ssh://git@localgit/secrets.git";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    deploy-rs.url = "github:serokell/deploy-rs";
  };
  outputs = {
    nixpkgs-stable,
    nixpkgs-unstable,
    home-manager,
    secrets,
    agenix,
    self,
    nix-minecraft,
    nixvim,
    deploy-rs,
    ...
  }: {
    nixosConfigurations.hexolexo = nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit secrets;
      };
      modules = [
        ./desktop/configuration.nix
        ./desktop/networking.nix
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager
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
      modules = [
        ./server/configuration.nix
        nix-minecraft.nixosModules.minecraft-servers
        {_module.args = {inherit nix-minecraft;};}
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
