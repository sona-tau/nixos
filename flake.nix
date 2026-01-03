{
	description = "Sona's super awesome flake.";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

		zen-browser.url = "github:0xc000022070/zen-browser-flake";

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
			url = "git+https://git.outfoxxed.me/outfoxxed/quickshell"; # add ?ref=<tag> to track a tag
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	# The `inputs@` part binds all of the parameters here to `inputs`
	outputs = inputs@{ self, nixpkgs, home-manager, stylix, ... }:
	let
		# Expose this flake's own outputs as a value that can be passed to modules
		inherit (self) outputs;

		# Extra arguments injected into all NixOS / Home Manager modules. Allows
		# modules to access flake inputs and other outputs without threading
		# them manually through imports
		specialArgs = { inherit inputs outputs; };
	in {
		nixosConfigurations."fw13" = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			inherit specialArgs;
			modules = [
				./machines/fw13/configuration.nix
				stylix."nixosModules".stylix
				home-manager.nixosModules.home-manager {
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users."sona" = import ./machines/fw13/home.nix;
						backupFileExtension = "bak";
					};
				}
			];
		};
	};
}
