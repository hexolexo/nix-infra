{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs = {
    self,
    nixpkgs,
    #nix-cachyos-kernel,
    agenix,
    disko,
    ...
  } @ inputs: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        ./disko.nix
        agenix.nixosModules.default
        disko.nixosModules.disko
      ];
    };
  };
}
