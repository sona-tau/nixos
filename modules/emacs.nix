{ ... }: {
	flake.modules.homeManager.emacs = { lib, pkgs, ... }: {
		home.packages = with pkgs; [
			symbola # used for fonts emacs can't render
			emacs-pgtk
            mu    # for email stuff
            isync # for email stuff
            texlive.combined.scheme-medium
            dvisvgm
		];
	};
}
