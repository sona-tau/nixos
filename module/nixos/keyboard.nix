{ config, pkgs, lib, ... }: {
	config = {
		home.file."/home/sona/.xkb/symbols/mtgap-mod".source = ../../config/mtgap-mod.xkb;
		console.useXkbConfig = true;
		services.xserver.xkb = {
			layout = "mtgap-mod";

			extraLayouts."mtgap-mod" = {
				description = "MTGAP Layout (modified)";
				symbolsFile = ../../configs/mtgap-mod.xkb;
				languages = [ "eng" ];
			};
		};
	};
}
