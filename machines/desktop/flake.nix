{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    conduit.url = "git+http://10.0.0.1:3000/hexolexo/Conduit.git";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    agenix,
    nixvim,
    conduit,
    ...
  } @ inputs: {
    nixosConfigurations.hexolexo-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager
        conduit.nixosModules.nixos-agent
        {
          home-manager.sharedModules = [nixvim.homeModules.nixvim];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.hexolexo = import ./home.nix;
        }
      ];
    };
  };
}
