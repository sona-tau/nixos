{ ... }: {
	flake.modules.homeManager.direnv = { config, lib, ... }: {
		config.programs.direnv = {
			enable = true;
			enableZshIntegration = config.my.shell == "zsh";
			nix-direnv.enable = true;
		};
	};
}
