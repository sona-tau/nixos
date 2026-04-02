{ config, pkgs, ... }: {
	programs.home-manager.enable = true;

	my.roles = {
		terminal.pkgSet.enable = true;
		base.pkgSet.enable = true;
	};

	home = {
		username = "sona";
		homeDirectory = "/home/sona";
		stateVersion = "24.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER !
	};
}
