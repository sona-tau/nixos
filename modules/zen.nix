{ ... }: {
	flake.modules.homeManager.zen = { config, lib, pkgs, ... }: let cfg = config.my.roles.zen; in {
		options = {
			my.roles.zen.enable = lib.mkEnableOption "The day arrives naturally";
		};

		config = lib.mkIf cfg.enable {
			home.file."${config.xdg.dataHome}" = {
				source = ../assets/fortune;
				recursive = true;
			};
		};
	};
}
