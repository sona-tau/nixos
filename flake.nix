{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
		zen-browser.url = "github:0xc000022070/zen-browser-flake";
		stylix.url = "github:danth/stylix";
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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

	outputs = inputs@{ self, nixpkgs, home-manager, stylix, nixos-hardware, ... }: let
		inherit (self) outputs;
		specialArgs = { inherit inputs outputs; };
		myLib = (import ./myLib) { inherit inputs outputs nixpkgs; };
	in {
		# nixosModules = import ./modules/nixos;
		# homeManagerModules = import ./modules/home;

		homeConfigurations = with myLib; {
			"sona" = mkHome "x86_64-linux" ./home/sona.nix [
				stylix.homeModules.stylix
			];
		};

		nixosConfigurations = with myLib; {
			"fw13" = mkSystem "x86_64-linux" ./machine/fw13/configuration.nix [
				nixos-hardware.nixosModules.framework-13th-gen-intel
			];
			"est" = mkSystem "x86_64-linux" ./machine/est/configuration.nix [ ];
			"hp" = mkSystem "x86_64-linux" ./machine/hp/configuration.nix [ ];
		};
	};
}
