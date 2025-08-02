{
	lib,
		pkgs,
		...
}: {
	stylix = {
		enable = true;
		autoEnable = true;
		base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

		image = ./waifu1.png;

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
