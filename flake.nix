{
  description = "Configuration NixOS de denis - Optiplex 7050";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    microvm.url = "github:microvm-nix/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    microvm,
    home-manager,
    ...
  }: {
    # Configuration principale de l'hôte
    nixosConfigurations.denislab = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs self;};
      modules = [
        microvm.nixosModules.host
        ./modules/system
        ./hosts/homelab
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            #users.denis = import ./modules/user;
            backupFileExtension = "backup";
            extraSpecialArgs = {inherit inputs;};
          };
        }
      ];
    };

    # Configuration pour la VM de Forgejo
    nixosConfigurations.forgejo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/forgejo
      ];
    };

    # Configuration de la VM microvm pour CI-runner
    nixosConfigurations.ci-microvm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        # Include the microvm module
        microvm.nixosModules.microvm
        ./hosts/ci-microvm
      ];
    };

    # Configuration pour la VM de test de Forgejo
    nixosConfigurations.forgejo-restore-test = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/forgejo-restore-test
      ];
    };
  };
}
