{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixt = {
      url = "github:nix-community/nixt/typescript-rewrite";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      recImport = nixpkgs.legacyPackages.x86_64-linux.callPackage ./utils/recImport.nix {};
      localModules = recImport ./modules;
    in {
    nixosConfigurations = {
      logos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # the system architecture
        modules =
          localModules ++ [
            home-manager.nixosModules.home-manager
            ./configuration.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ldlework = import ./home.nix;
            }
          ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
