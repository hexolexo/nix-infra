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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets.url = "git+http://10.0.0.1:3000/hexolexo/secrets.git";
  };

  outputs = {
    nixpkgs,
    home-manager,
    agenix,
    nixvim,
    secrets,
    ...
  }: {
    nixosConfigurations.hexolexo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit secrets;};
      modules = [
        ./configuration.nix
        ./networking.nix
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager
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
