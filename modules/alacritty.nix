{ ... }: {
	flake.modules.homeManager.alacritty = { config, lib, pkgs, ... }: {
		config.programs.alacritty = {
			enable = true;

			settings = {
				font.size = 13;

				window = {
					opacity = lib.mkForce 1.0;

					padding = {
						x = 10;
						y = 10;
					};
				};
			};
		};
	};
}
