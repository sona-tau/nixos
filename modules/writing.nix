{ ... }: {
	flake.modules.homeManager.writing = { pkgs, ... }: {
		home.packages = with pkgs; [
			# texliveFull     # the whole LaTex suite
			typst           # Markdown + LaTex = typst compiler
		];
	};
}
