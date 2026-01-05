{ config, lib, pkgs, ... }: {
	stylix = {
		enable = true;
		autoEnable = true;
		base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.theme}.yaml";
		# image = ./waifu1.png;
		targets.plymouth.enable = false;

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
	};
}
