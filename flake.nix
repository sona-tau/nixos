{
	description = "A very basic flake";

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
			url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ self, nixpkgs, home-manager, stylix, ... }: let
		inherit (self) outputs;
		specialArgs = { inherit inputs outputs; };
		myLib = (import ./myLib) { inherit inputs outputs nixpkgs; };
	in {
		# nixosModules = import ./modules/nixos;
		# homeManagerModules = import ./modules/home;

		homeConfigurations = with myLib; {
			"sona" = mkHome "x86_64-linux" ./home/sona.nix [];
		};

		nixosConfigurations = with myLib; {
			"fw13" = mkSystem "x86_64-linux" ./machine/fw13/configuration.nix [
				stylix.nixosModules.stylix
			];
		};
	};
}
