{ ... }: {
	flake.modules.homeManager.wallpapers = { config, lib, ... }: let cfg = config.my.wallpapers; in {
		options.my.wallpapers.enable = lib.mkEnableOption "wallpapers";

		config = lib.mkIf cfg.enable {
			home.file."Wallpapers" = {
				enable = true;
				recursive = true;
				target = "Media/Pictures/Wallpapers";
				source = ../assets/media;
			};
		};
	};
}
