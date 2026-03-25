{ config, lib, ... }:
let cfg = config.terminal; in
{
	options.terminal = {
		foot = {
			enable = lib.mkEnableOption "foot";
		};
	};

	config = {
		programs = {
			foot = lib.mkIf cfg.foot.enable {
				enable = true;
				server.enable = true;
			};
		};
	};
}
