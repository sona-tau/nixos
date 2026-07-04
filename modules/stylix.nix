{ ... }: {
	flake.modules.homeManager.stylix = { config, lib, inputs, pkgs, ... }: let cfg = config.my.stylix; in {
		imports = [
			inputs.stylix.homeModules.stylix
		];

		options = {
			my.stylix = {
				theme = lib.mkOption {
					default = "catppuccin";
					type = lib.types.str;
					description = "The theme you want to use.";
				};
				wallpaper = lib.mkOption {
					# default = 
					type = lib.types.path;
					description = "The wallpaper you want to use.";
				};
			};
		};

		config = {
			stylix = {
				enable = true;
				autoEnable = true;
				overlays.enable = false;
				base16Scheme = if cfg.theme == "zenbones"
					then import ../assets/themes/zenbones.nix
					else if cfg.theme == "moonfly"
					then import ../assets/themes/moonfly.nix
					else if cfg.theme == "catppuccin"
					then "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml"
					else "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";

				image = lib.mkIf (cfg ? wallpaper) cfg.wallpaper;

				fonts = {
					monospace = {
						package = pkgs.mno16;
						name = "Mno16";
					};

					sansSerif = {
						package = pkgs.vegur;
						name = "Vegur";
					};

					serif = {
						package = pkgs.medio;
						name = "Medio";
					};

					sizes = {
						applications = 13;
						terminal = 13;
						desktop = 13;
						popups = 10;
					};
				};

				cursor = {
					name = lib.mkForce "BreezeX-RosePine-Linux";
					package = lib.mkForce pkgs.rose-pine-cursor;
					size = 32;
				};

				targets.kde.enable = false;
			};
		};
	};
}
