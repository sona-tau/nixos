{
    description = "A very basic flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
        zen-browser = {
			url = "github:0xc000022070/zen-browser-flake";
		};
        stylix.url = "github:danth/stylix";
        niri = {
            url = "github:sodiboo/niri-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
		quickshell = {
			# add ?ref=<tag> to track a tag
			url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};
    };

    outputs = inputs@{ self, nixpkgs, home-manager, stylix, ... }:
    let
        inherit (self) outputs;
        specialArgs = { inherit inputs outputs; };
    in {
        nixosConfigurations.fw13 = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = [
                ./hosts/fw13/configuration.nix
                stylix.nixosModules.stylix
                home-manager.nixosModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.diego = import ./hosts/fw13/home.nix;
                        backupFileExtension = "backup";
                    };
                }
            ];
        };
    };
}
