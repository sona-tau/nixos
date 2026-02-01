{ config, pkgs, lib, hostname, ... }:
let cfg = config.rice.nier; in
{
	config = lib.mkIf cfg.enable {
		programs = {
			lutris.enable = true;
		};
	};
}
