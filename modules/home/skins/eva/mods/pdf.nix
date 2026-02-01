{ config, lib, pkgs, ... }:
let cfg = config.pdf; in
{
	options.pdf = {
		enable = lib.mkEnableOption "pdf";
	};

	config = lib.mkIf cfg.enable {
		programs = {
			zathura = {
				enable = true;
			};
		};

		home.packages = [
			pkgs.texlive.combined.scheme-full
		];
	};
}

