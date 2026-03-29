{ config, lib, pkgs, ... }: let cfg = config.my.eww; in {
	options.my.eww.enable = lib.mkEnableOption "eww";

	config = lib.mkIf cfg.enable {
		programs.eww = {
			enable = true;
			configDir = ../assets/eww;
		};
	};
}
