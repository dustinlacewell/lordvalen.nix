{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixt = {
      url = "github:nix-community/nixt/typescript-rewrite";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      logos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # the system architecture
        modules = [
            home-manager.nixosModules.home-manager
            ./configuration.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lord-valen = import ./home.nix;
            }
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
