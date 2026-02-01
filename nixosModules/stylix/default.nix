{
	lib,
		pkgs,
		...
}: {
	stylix = {
		enable = true;
		autoEnable = true;
		# base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
		base16Scheme = {
			slug = "zenbones";
			scheme = "Theme by zenbones-theme";
			author = "zenbones-theme";
			base00 = "#1C1917";
			base01 = "#2F2E2D";
			base02 = "#424242";
			base03 = "#686B6D";
			base04 = "#8E9498";
			base05 = "#A1A9AE";
			base06 = "#ABB3B9";
			base07 = "#B4BDC3";
			base08 = "#DE6E7C";
			base09 = "#B77E64";
			base0A = "#D68C67";
			base0B = "#819B69";
			base0C = "#66A5AD";
			base0D = "#6099C0";
			base0E = "#B279A7";
			base0F = "#403833";
		};

		image = ./waifu1.png;

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
