{
	lib,
		pkgs,
		...
}: {
	stylix = {
		enable = true;
		autoEnable = true;
		base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

		image = ./fushitsushawp1.jpg;

		fonts = {
			monospace = {
				package = pkgs.bqn386;
				name = "BQN386 Unicode";
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

		/*
		   cursor = {
		   name = "banana-cursor";
		   package = pkgs.banana-cursor;
		   };
		 */

		targets.plymouth.enable = false;

		/*
		   targets = {
		   grub.enable = true;
		   grub.useImage = true;
		   plymouth.enable = true;
		   };
		 */
	};
}
