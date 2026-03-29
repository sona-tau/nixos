{ config, lib, ... }: let cfg = config.my.tealdeer; in {
	options.my.tealdeer.enable = lib.mkEnableOption "tealdeer";

	config = lib.mkIf cfg.enable {
		programs.tealdeer = {
			enable = true;
			settings.updates.auto_update = true;
		};
	};
}
