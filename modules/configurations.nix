{ config, inputs, withSystem, ... }: {
	flake.nixosConfigurations = {
		"fw13" = withSystem "x86_64-linux" (perSystem@{ pkgs, ... }: inputs.nixpkgs.lib.nixosSystem {
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
							zen-browser = perSystem.config.packages.zen-browser;
						};

						users."sona" = {
							imports = with config.flake.modules.homeManager; [
								alacritty
								atuin
								base
								browsers
								direnv
								gtk
								icons
								mako
								minecraft
								noctalia
								sh-prompt
								shell
								starship
								stylix
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
		});
		"est" = withSystem "x86_64-linux" ({ pkgs, ... }: inputs.nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";

			specialArgs = {
				inherit inputs;
			};

			modules = [
				inputs.home-manager.nixosModules.home-manager
				config.flake.modules.nixos.base
				../machine/est/configuration.nix
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						backupFileExtension = ".bak";
						extraSpecialArgs = {
							inherit inputs;
						};

						users."sona" = {
							imports = with config.flake.modules.homeManager; [
								atuin
								base
								direnv
								gaming
								gtk
								icons
								mako
								noctalia
								sh-prompt
								shell
								starship
								stylix
								tealdeer
								tmux
								utilities
								wallpapers
								wayland
								zen
								zsh
								../machine/est/sona.nix
							];
						};
					};
				}
			];
		});

		"hp" = withSystem "x86_64-linux" ({ pkgs, ... }: inputs.nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";

			specialArgs = {
				inherit inputs;
			};

			modules = [
				inputs.home-manager.nixosModules.home-manager
				config.flake.modules.nixos.base
				../machine/hp/configuration.nix
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						backupFileExtension = ".bak";
						extraSpecialArgs = {
							inherit inputs;
						};

						users."sona" = {
							imports = with config.flake.modules.homeManager; [
								atuin
								base
								direnv
								sh-prompt
								shell
								starship
								tealdeer
								tmux
								utilities
								zsh
								../machine/hp/sona.nix
							];
						};
					};
				}
			];
		});
	};
}
