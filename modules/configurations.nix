{ config, inputs, ... }: {
	flake.nixosConfigurations = {
		"fw13" = withSystem "x86_64-linux" ({ pkgs, ... }: inputs.nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";

			specialArgs = {
				inherit inputs;
			};

			modules = [
				inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
				inputs.home-manager.nixosModules.home-manager
				config.flake.modules.nixos.base
				../machine/fw13/configuration.nix
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						backupFileExtension = ".bak";
						extraSpecialArgs = {
							inherit inputs;
							zen-browser = pkgs.zen-browser;
						};

						users."sona" = {
							imports = with config.flake.modules.homeManager; [
								alacritty
								anyrun
								atuin
								base
								browsers
								direnv
								eww
								foot
								gammastep
								gtk
								icons
								mako
								minecraft
								niri
								noctalia
								quickshell
								sh-prompt
								shell
								starship
								stylix
								sway
								tealdeer
								tmux
								utilities
								wallpapers
								wayland
								zathura
								zen
								zsh
								../machine/fw13/sona.nix
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
