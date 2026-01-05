{ config, pkgs, lib, ... }: {
	config.home.file.".config/waypaper/config.ini".source = ./configs/waypaper.ini;
}
