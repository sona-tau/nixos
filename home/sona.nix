{ config, outputs, pkgs, ... }: {
	imports = [
		../modules/home
		# ../module/home/my.nix
	];

	rice.nier.enable = true;
	programs.home-manager.enable = true;

	my = {
		shell = "zsh";
		roles = {
			wayland.pkgSet.enable = true;
			terminal.pkgSet.enable = true;
			browsers.pkgSet.enable = true;
			webdev.pkgSet.enable = true;
			lean.pkgSet.enable = true;
			fun.pkgSet.enable = true;
			writing.pkgSet.enable = true;

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
			theme = "zenbones";
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
		file."/home/sona/.xkb/symbols/mtgap-mod".source = ../assets/mtgap-mod.xkb;
	};
}
