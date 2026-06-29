{ ... }: {
	flake.modules.homeManager.webdev = { pkgs, ... }: {
		home.packages = with pkgs; [
			hugo            # website builder
			kubo
			amfora
		];
	};
}
