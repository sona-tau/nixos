{ ... }: {
	flake.modules.homeManager.zen = { config, ... }: {
		home.file."${config.xdg.dataHome}" = {
			source = ../assets/fortune;
			recursive = true;
		};

		programs.zsh.initContent = ''fortune ~/.local/share/fortune/zen'';
	};
}
