{ config, lib, pkgs, ... }:
let cfg = config.browse; in
{
	options.browse = with lib; {
		enable = mkEnableOption "browse";
		floorp = {
			enable = mkEnableOption "floorp";
		};
		librewolf = {
			enable = mkEnableOption "librewolf";
		};
                qutebrowser = {
                    enable = mkEnableOption "qutebrowser";
                };
	};

	config = with lib; lib.mkIf cfg.enable {
		programs.librewolf = mkIf cfg.librewolf.enable {
			enable = true;
		};

                programs.qutebrowser = mkIf cfg.qutebrowser.enable {
                enable = true;
                };

		home.packages = mkIf cfg.floorp.enable [
			pkgs.floorp
		];
	};
}
