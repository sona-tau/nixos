{ config, lib, pkgs, ... }:
let cfg = config.moduleNameHere; in
{
	options.moduleNameHere = {
		enable = lib.mkEnableOption "moduleNameHere";
	};

	config = lib.mkIf cfg.enable {
	};
}
