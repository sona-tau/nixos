{ homeModules, ... }: {
	programs.home-manager.enable = true;

	imports = with homeModules; [
		base
		fun
		gaming
		gtk
		icons
		mako
		noctalia
		stylix
		terminal
		wallpapers
		wayland
		zen
	];

	my.stylix = {
		theme = "oxocarbon-dark";
		wallpaper = ../../assets/media/full/wall2.png;
	};

	home = {
		username = "sona";
		homeDirectory = "/home/sona";
		stateVersion = "23.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER !
	};
}
