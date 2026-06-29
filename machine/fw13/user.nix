{ homeModules, ... }: {
	programs.home-manager.enable = true;

	imports = with homeModules; [
		base
		alacritty
		bluesky
		browsers
		kagi
		keyring
		offline-docs
		email
		fun
		gtk
		icons
		lean
		llm
		mako
		neovim
		emacs
		taskwarrior
		minecraft
		noctalia
		stylix
		terminal
		wallpapers
		wayland
		w3m
		webdev
		writing
		zathura
		zen
	];

	my.stylix = {
		theme = "oxocarbon-dark";
		wallpaper = ../../assets/media/full/EvaUnits_oxocarbon-dark_hald8_GaussianRBF_lum1_shape96_near16.png;
	};

	home = {
		username = "sona";
		homeDirectory = "/home/sona";
		stateVersion = "23.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER !
		file."/home/sona/.xkb/symbols/mtgap-mod".source = ../../assets/mtgap-mod.xkb;
	};
}
