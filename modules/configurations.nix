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
				inputs.sops-nix.nixosModules.sops
				config.flake.modules.nixos.base
				config.flake.modules.nixos.common
				../machine/fw13/hardware.nix
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
				inputs.sops-nix.nixosModules.sops
				config.flake.modules.nixos.base
				config.flake.modules.nixos.common
				../machine/est/hardware.nix
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
				inputs.sops-nix.nixosModules.sops
				config.flake.modules.nixos.base
				config.flake.modules.nixos.common
				config.flake.modules.nixos.monitoring
				config.flake.modules.nixos.glance
				config.flake.modules.nixos.readeck
				config.flake.modules.nixos.pinchflat
				config.flake.modules.nixos.firefly
				config.flake.modules.nixos.fidi
				config.flake.modules.nixos.kubo
				config.flake.modules.nixos.metube
				config.flake.modules.nixos.grocy
				config.flake.modules.nixos.monica
				../machine/hp/hardware.nix
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
