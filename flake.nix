{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
		zen-browser.url = "github:0xc000022070/zen-browser-flake";
		stylix.url = "github:danth/stylix";
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";
		noctalia = {
			url = "github:noctalia-dev/noctalia-shell";
			inputs.nixpkgs.follows = "nixpkgs";
		};

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

	outputs = inputs@{ self, nixpkgs, home-manager, stylix, nixos-hardware, noctalia, ... }: let
		inherit (self) outputs;
		specialArgs = { inherit inputs outputs; };
		myLib = (import ./myLib) { inherit inputs outputs nixpkgs; };
	in {
		nixosConfigurations = with myLib; {
			"fw13" = mkSystem {
				user = "sona";
				system = "x86_64-linux";
				hostname = "fw13";
				nixosModules = [
					nixos-hardware.nixosModules.framework-13th-gen-intel 
				];
			};

			"est" = mkSystem {
				system = "x86_64-linux"; 
				config = ./machine/est/configuration.nix;
				homeModules = [ ];
				nixosModules = [ ];
			};

			"hp" = mkSystem {
				system = "x86_64-linux";
				config = ./machine/hp/configuration.nix; 
				homeModules = [ ];
				nixosModules = [ ];
			};
		};
	};
}
