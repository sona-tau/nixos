{ homeModules, ... }: {
	programs.home-manager.enable = true;

	imports = with homeModules; [
		base
		alacritty
		browsers
		email
		fun
		gtk
		icons
		lean
		llm
		mako
		minecraft
		noctalia
		stylix
		terminal
		wallpapers
		wayland
		webdev
		writing
		zathura
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
		file."/home/sona/.xkb/symbols/mtgap-mod".source = ../../assets/mtgap-mod.xkb;
	};
}
