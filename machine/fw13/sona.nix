{ config, outputs, stylix, pkgs, ... }: {
	imports = [
		../../homeModules
	];

	programs.home-manager.enable = true;

	my = {
		shell = "zsh";
		zathura.enable = true;
		sway.enable = true;
		foot.enable = true;
		noctalia.enable = true;
		wallpapers.enable = true;

		roles = {
			terminal.pkgSet.enable = true;
			browsers.pkgSet.enable = true;
			webdev.pkgSet.enable = true;
			lean.pkgSet.enable = true;
			fun.pkgSet.enable = true;
			writing.pkgSet.enable = true;
			wayland.enable = true;
			browsers.enable = true;
			email.pkgSet.enable = true;
			llm.pkgSet.enable = true;

			zen = {
				enable = true;
				pkgSet.enable = true;
			};

			base = {
				enable = true;
				pkgSet.enable = true;
			};
		};

		stylix = {
			enable = true;
			theme = "oxocarbon-dark";
			wallpaper = ../../assets/media/full/wall2.png;
		};
		starship.enable = true;
		atuin.enable = true;
		direnv.enable = true;
		tealdeer.enable = true;
		tmux.enable = true;
	};

	home = {
		username = "sona";
		homeDirectory = "/home/sona";
		stateVersion = "23.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER !
		file."/home/sona/.xkb/symbols/mtgap-mod".source = ../../assets/mtgap-mod.xkb;
	};
}
