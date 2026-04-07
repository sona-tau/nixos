{ config, inputs, withSystem, ... }: let
	mkHomeManager = extraSpecialArgs: {
		useGlobalPkgs = true;
		useUserPackages = true;
		backupFileExtension = ".bak";
		extraSpecialArgs = {
			inherit inputs;
			homeModules = config.flake.modules.homeManager;
		} // extraSpecialArgs;
	};
in {
	flake.nixosConfigurations = {
		"fw13" = withSystem "x86_64-linux" (perSystem@{ ... }: inputs.nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
				inputs.home-manager.nixosModules.home-manager
				perSystem.config.flake.modules.nixos.base
				perSystem.config.flake.modules.nixos.common
				../machine/fw13/os.nix
				{
					home-manager = (mkHomeManager {
						zen-browser = perSystem.config.packages.zen-browser;
					}) // {
						users."sona".imports = [ ../machine/fw13/user.nix ];
					};
				}
			];
		});

		"est" = inputs.nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				inputs.home-manager.nixosModules.home-manager
				config.flake.modules.nixos.base
				config.flake.modules.nixos.common
				../machine/est/os.nix
				{
					home-manager = (mkHomeManager {}) // {
						users."sona".imports = [ ../machine/est/user.nix ];
					};
				}
			];
		};

		"hp" = inputs.nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				inputs.home-manager.nixosModules.home-manager
				config.flake.modules.nixos.base
				config.flake.modules.nixos.common
				../machine/hp/os.nix
				{
					home-manager = (mkHomeManager {}) // {
						users."sona".imports = [ ../machine/hp/user.nix ];
					};
				}
			];
		};
	};
}
