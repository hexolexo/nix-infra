{
  inputs = {
    vault.url = "path:./machines/vault";
    hexolexo.url = "path:./machines/laptop";
    hexolexo-pc.url = "path:./machines/desktop";
    bootstrap.url = "path:./machines/bootstrap";

    deploy-rs.url = "github:serokell/deploy-rs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    vault,
    hexolexo,
    hexolexo-pc,
    bootstrap,
    deploy-rs,
    nixpkgs,
    agenix,
    ...
  }: {
    nixosConfigurations = {
      vault = vault.nixosConfigurations.vault;
      hexolexo = hexolexo.nixosConfigurations.hexolexo;
      hexolexo-pc = hexolexo-pc.nixosConfigurations.hexolexo-pc;
      bootstrap = bootstrap.nixosConfigurations.bootstrap;
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

    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      packages = [
        deploy-rs.packages.x86_64-linux.default
        agenix.packages.x86_64-linux.default
        nixpkgs.legacyPackages.x86_64-linux.nixos-anywhere
      ];
    };

    packages.x86_64-linux.bootstrap =
      bootstrap.nixosConfigurations.bootstrap.config.system.build.isoImage;
  };
}
