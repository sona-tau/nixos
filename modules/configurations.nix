{ config, inputs, ... }: {
	flake.nixosConfigurations = {
		"fw13" = {
			system = "x86_64-linux";
			modules = [
				inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
				inputs.home-manager.nixosModules.home-manager
				config.flake.modules.nixos.base
				./machine/fw13/configuration.nix
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						backupFileExtension = ".bak";
						users."sona" = {
							imports = [
								config.flake.modules.homeManager.base
								./machine/fw13/sona.nix
							];
						};
					};
				}
			];
		};
		/*
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
		*/
	};
}
