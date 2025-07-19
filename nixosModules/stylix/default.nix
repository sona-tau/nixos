{
	lib,
		pkgs,
		...
}: {
	stylix = {
		enable = true;
		autoEnable = true;
		base16Scheme = {
			slug = "moonfly";
			scheme = "Theme by bluz71";
			author = "bluz71";
			base00 = "#080808";
			base01 = "#323437";
			base02 = "#949494";
			base03 = "#9e9e9e";
			base04 = "#bdbdbd";
			base05 = "#c6c6c6";
			base06 = "#e4e4e4";
			base07 = "#eeeeee";
			base08 = "#ff5454";
			base09 = "#8cc85f";
			base0A = "#e3c78a";
			base0B = "#80a0ff";
			base0C = "#cf87e8";
			base0D = "#79dac8";
			base0E = "#c6c6c6";
			base0F = "#949494";
		}; # "${pkgs.base16-schemes}/share/themes/material-darker.yaml";

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
