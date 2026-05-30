{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    clankhare.url = "github:hexolexo/clankhare";
    conduit.url = "git+http://10.0.0.1:3000/hexolexo/Conduit.git";
    secrets.url = "path:/home/hexolexo/Programming/sysadmin/secrets";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    disko,
    agenix,
    copyparty,
    nix-minecraft,
    clankhare,
    conduit,
    secrets,
    ...
  } @ inputs: {
    nixosConfigurations.vault = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit secrets inputs nix-minecraft;};
      modules = [
        disko.nixosModules.disko
        ./configuration.nix
        ./disko.nix
        copyparty.nixosModules.default
        clankhare.nixosModules.default
        agenix.nixosModules.default
        conduit.nixosModules.nats
        conduit.nixosModules.libvirt-agent
        conduit.nixosModules.wireguard-agent
        conduit.nixosModules.nixos-agent
        nix-minecraft.nixosModules.minecraft-servers
        ({...}: {
          nixpkgs.overlays = [copyparty.overlays.default nix-minecraft.overlays.default];
          environment.systemPackages = [clankhare.packages.x86_64-linux.default];
        })
        home-manager.nixosModules.home-manager
        {
          home-manager.sharedModules = [
            nixvim.homeModules.nixvim
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.hexolexo = import ./home.nix;
        }
      ];
    };
  };
}
