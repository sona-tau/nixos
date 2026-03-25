{ config, lib, pkgs, ... }: let cfg = config.my.gammastep; in {
	options.my.gammastep.enable = lib.mkEnableOption "gammastep";

	config = lib.mkIf cfg.enable {
		services.gammastep = {
			enable = true;
			dawnTime = "05:48-06:59";
			duskTime = "17:47-19:04";
			temperature = {
				night = 2000;
			};
		};
	};
}
