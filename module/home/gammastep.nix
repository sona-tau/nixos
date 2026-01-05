{ config, pkgs, lib, ... }: {
	config.services.gammastep = {
		enable = true;
		dawnTime = "05:48-06:59";
		duskTime = "17:47-19:04";
		temperature.night = 2000;
	};
}
