{ config, pkgs, lib, ... }:
let cfg = config.moduleNameHere; in
{
	home.file.".config/applicationConfigHere/config.ext" = {
		source = ./dots/applicationNameHere.ext;
	};
}
