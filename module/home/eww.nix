{ config, ... }: {
	config.programs.eww = {
		enable = true;
		configDir = ./../../configs/eww;
	};
}
