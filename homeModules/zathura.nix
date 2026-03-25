{ config, lib, ... }: let cfg = config.my.zathura; in {
	options = {
		my.zathura.enable = lib.mkEnableOption "zathura";
	};

	config.programs.zathura = lib.mkIf cfg.enable {
		enable = true;
		options = {
			"recolor" = true;
		};
	};
}
