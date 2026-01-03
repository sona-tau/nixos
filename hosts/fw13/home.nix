{ config, pkgs, ... }: {
	imports = [
		../../modules/home
	];
	home = {
		username = "sona";
		homeDirectory = "/home/sona";
		stateVersion = "23.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER
		file."/home/sona/.xkb/symbols/mtgap-mod".source = ./mtgap-mod.xkb;
	};
	rice.nier.enable = true;
	programs.home-manager.enable = true;
}
