{ homeModules, ... }: {
	programs.home-manager.enable = true;

	imports = with homeModules; [
		base
		terminal
	];

	home = {
		username = "sona";
		homeDirectory = "/home/sona";
		stateVersion = "24.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER !
	};
}
