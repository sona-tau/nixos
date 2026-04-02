{
	description = "Sona's super awesome flake.";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
		zen-browser.url = "github:0xc000022070/zen-browser-flake";
		stylix.url = "github:danth/stylix";
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";
		flake-parts.url = "github:hercules-ci/flake-parts";
		import-tree.url = "github:vic/import-tree";

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

	# The `inputs@` part binds all of the parameters here to `inputs`
	outputs = inputs@{ flake-parts, ... }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			systems = [ "x86_64-linux" ];

			imports = let
				lib = inputs.nixpkgs.lib;
				modulesPath = ./modules;
			in lib.filter (lib.hasSuffix ".nix") (lib.filesystem.listFilesRecursive modulesPath);
		};
}
