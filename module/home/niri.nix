{ config, pkgs, ... }: {
	config.home = {
		file.".config/niri/config.kdl".source = ./../../configs/niri/config.kdl;
		packages = [ pkgs.niri ];
	};
}
