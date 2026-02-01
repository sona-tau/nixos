{ config, outputs, pkgs, ... }: {
	imports = [
		../homeManagerModules
		# ../module/home/my.nix
	];

	rice.nier.enable = true;
	programs.home-manager.enable = true;

	home = {
		username = "sona";
		homeDirectory = "/home/sona";
		stateVersion = "23.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER !
		file."/home/sona/.xkb/symbols/mtgap-mod".source = ../assets/mtgap-mod.xkb;
	};
}
