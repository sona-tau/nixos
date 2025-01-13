{ config, lib, pkgs, ... }:
let cfg = config.specialFonts; in
{
	options.specialFonts = {
		enable = lib.mkEnableOption "specialFonts";
	};

	config = lib.mkIf cfg.enable {
		home.packages = with pkgs; [
			ipafont
			ipaexfont
			takao
			nerdfonts
			fira-code-nerdfont
		];
	};
}
