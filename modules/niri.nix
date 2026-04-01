{ ... }: {
	flake.modules.homeManager.niri = { config, lib, pkgs, ... }: let cfg = config.my.niri; in {
		options.my.niri.enable = lib.mkEnableOption "niri";

		config = lib.mkIf cfg.enable {
			my = {
				mako.enable = true;
				icons.enable = true;
			};

			services.swww.enable = true;

			programs = {
				anyrun.enable = true;
			};

			home = {
				file.".config/niri/config.kdl".source = ../assets/niri/config.kdl;
				packages = with pkgs; [ niri ];
			};
		};
	};
}
