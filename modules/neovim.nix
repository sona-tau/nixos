{ ... }: {
	flake.modules.homeManager.neovim = { config, pkgs, ... }: {
		programs.neovim = {
			enable = true;
			defaultEditor = true;
			viAlias = true;
			vimAlias = true;
		};

		xdg.configFile."nvim".source =
			config.lib.file.mkOutOfStoreSymlink "/home/sona/nixos/assets/nvim";
	};
}
