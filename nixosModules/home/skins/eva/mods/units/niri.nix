{ config, pkgs, lib, ... }:
{
	home.file.".config/niri/config.kdl" = {
		source = ./dots/niri.kdl;
	};
}
