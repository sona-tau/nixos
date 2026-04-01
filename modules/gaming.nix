{ ... }: {
	flake.modules.homeManager.gaming = { config, lib, pkgs, ... }: let cfg = config.my.gaming; in {
		options.my.gaming.enable = lib.mkEnableOption "gaming";

		config = lib.mkIf cfg.enable {
			programs.lutris.enable = true;
		};
	};
}
