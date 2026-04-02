{ config, pkgs, ... }: {
	programs.home-manager.enable = true;

	my = {
		roles = {
			terminal.pkgSet.enable = true;
			fun.pkgSet.enable = true;
			zen.pkgSet.enable = true;
			base.pkgSet.enable = true;
			wayland.pkgSet.enable = true;
		};

		stylix = {
			theme = "oxocarbon-dark";
			wallpaper = ../../assets/media/full/wall2.png;
		};
	};

	home = {
		username = "sona";
		homeDirectory = "/home/sona";
		stateVersion = "24.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER !
	};
}
