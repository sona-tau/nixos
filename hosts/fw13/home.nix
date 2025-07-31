{ config, pkgs, ... }: {
    imports = [
        ../../homeManagerModules
    ];
    home = {
		username = "diego";
		homeDirectory = "/home/diego";
		stateVersion = "23.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER !
		file."/home/diego/.xkb/symbols/mtgap-mod".source = ./mtgap-mod.xkb;
	};
    rice.nier.enable = true;
    programs.home-manager.enable = true;
}
