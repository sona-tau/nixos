{ config, lib, pkgs, ... }: let cfg = config.my.stylix; in {
	options = {
		my.stylix = {
			enable = lib.mkEnableOption "stylix";
			theme = lib.mkOption {
				default = "catppuccin";
				type = lib.types.str;
				description = "The theme you want to use.";
			};
		};
	};

	config = lib.mkIf cfg.enable {
		stylix = {
			enable = true;
			autoEnable = true;
			base16Scheme = if cfg.theme == "zenbones"
				then import ../../assets/themes/zenbones.nix
				else if cfg.theme == "moonfly"
				then import ../../assets/themes/moonfly.nix
				else lib.mkIf cfg.theme == "catppuccin"
				"${pkgs.base16-scheme}/share/themes/catppuccin-mocha.yaml";

			image = ../../assets/wp/lock-in_large.png;

			fonts = {
				monospace = {
					package = pkgs.hermit;
					name = "Hermit";
				};

				sansSerif = {
					package = pkgs.dejavu_fonts;
					name = "DejaVu Sans";
				};

				serif = {
					package = pkgs.dejavu_fonts;
					name = "DejaVu Serif";
				};

				sizes = {
					applications = 12;
					terminal = 13;
					desktop = 10;
					popups = 10;
				};
			};

			cursor = {
				name = lib.mkForce "BreezeX-RosePine-Linux";
				package = lib.mkForce pkgs.rose-pine-cursor;
				size = 32;
			};

			# targets.plymouth.enable = false;
		};
	};
}
