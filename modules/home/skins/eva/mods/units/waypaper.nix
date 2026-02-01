{ config, pkgs, lib, ... }:
{
	home.file.".config/waypaper/config.ini" = {
		source = ./dots/waypaper.ini;
	};
}
