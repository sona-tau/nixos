{ ... }: {
	flake.modules.homeManager.emacs = { config, lib, pkgs, ... }: {
		home.packages = with pkgs; [
			symbola # used for fonts emacs can't render
			emacs-pgtk
            mu    # for email stuff
            isync # for email stuff
            texlive.combined.scheme-medium
            dvisvgm
            cmake  # vterm compilation
            gnumake  # vterm compilation
		];

		xdg.configFile."doom".source =
			config.lib.file.mkOutOfStoreSymlink
				"${config.home.homeDirectory}/nixos/assets/emacs/doom";
	};
}
