{
  inputs = {
    vault.url = "path:./machines/vault";
    hexolexo.url = "path:./machines/desktop";
    deploy-rs.url = "github:serokell/deploy-rs";

    # desktop still lives here until it gets the same treatment
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    secrets.url = "path:/home/hexolexo/Programming/sysadmin/secrets";
  };

  outputs = {
    self,
    vault,
    hexolexo,
    deploy-rs,
    nixpkgs-unstable,
    agenix,
    ...
  }: {
    nixosConfigurations = {
      vault = vault.nixosConfigurations.vault;
      hexolexo = hexolexo.nixosConfigurations.hexolexo;
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

    devShells.x86_64-linux.default = nixpkgs-unstable.legacyPackages.x86_64-linux.mkShell {
      packages = [
        deploy-rs.packages.x86_64-linux.default
        agenix.packages.x86_64-linux.default
        nixpkgs-unstable.legacyPackages.x86_64-linux.nixos-anywhere
      ];
    };

    #packages.x86_64-linux.bootstrap =
    #self.nixosConfigurations.bootstrap.config.system.build.isoImage;
  };
}
