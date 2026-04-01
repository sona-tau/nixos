{ ... }: {
	flake.modules.homeManager.wayland = { config, lib, pkgs, ... }: let cfg = config.my.roles.wayland; in {
		options.my.roles.wayland.enable = lib.mkEnableOption "wayland";

		config = lib.mkIf cfg.enable {
			
			my = {
				eww.enable = true;
				foot.enable = true;
				gammastep.enable = true;
				niri.enable = true;
				quickshell.enable = true;
				sway.enable = true;
				roles.wayland.pkgSet.enable = true;
			};
		};
	};
}
