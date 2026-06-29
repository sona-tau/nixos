{ ... }: {
	flake.modules.homeManager.eww = { ... }: {
		programs.eww = {
			enable = true;
			# configDir = ../assets/eww;
		};
	};
}
