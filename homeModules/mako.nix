{ config, lib, pkgs, ... }: let cfg = config.my.mako; in {
	options.my.mako.enable = lib.mkEnableOption "mako";

	config = lib.mkIf cfg.enable {
		services.mako = {
			enable = true;
		};
	};
}
