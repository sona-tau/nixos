{ ... }: {
	flake.modules.homeManager.fun = { pkgs, ... }: {
		home.packages = with pkgs; [
			cmatrix         # will you take the red pill, or the blue pill
			cowsay          # cow say
			steam           # video games
			tic-80          # fantasy computer emulator
		];
	};
}
