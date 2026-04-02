{ config, outputs, stylix, pkgs, ... }: {
	programs.home-manager.enable = true;

	my = {
		roles = {
			terminal.pkgSet.enable = true;
			browsers.pkgSet.enable = true;
			webdev.pkgSet.enable = true;
			lean.pkgSet.enable = true;
			fun.pkgSet.enable = true;
			writing.pkgSet.enable = true;
			wayland.pkgSet.enable = true;
			email.pkgSet.enable = true;
			llm.pkgSet.enable = true;
			zen.pkgSet.enable = true;
			base.pkgSet.enable = true;
		};

		stylix = {
			theme = "oxocarbon-dark";
			wallpaper = ../../assets/media/full/wall2.png;
		};
	};

	home = {
		username = "sona";
		homeDirectory = "/home/sona";
		stateVersion = "23.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER !
		file."/home/sona/.xkb/symbols/mtgap-mod".source = ../../assets/mtgap-mod.xkb;
	};
}
