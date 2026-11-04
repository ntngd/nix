{
  description = "NixOS Flake Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangobar = {
      url = "github:mangowm/mangobar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nordvpn-nixos.url = "github:morettimarco/nordvpn-nixos";

  };

  outputs = { self, nixpkgs, mango, mangobar, home-manager, nordvpn-nixos, ... }@inputs: {
    nixosConfigurations = {
      knix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
          
          mango.nixosModules.mango

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ntngd = {
              imports = [
                ./home.nix
              ];
            };
          }
	  nordvpn-nixos.nixosModules.default
        ];
      };
    };
  };
   
}
