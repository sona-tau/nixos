{ ... }: {
	flake.modules.homeManager.terminal = { pkgs, ... }: {
		home.packages = with pkgs; [
			cloc            # count lines of code
			glow            # markdown preview
			gum             # terminal forms
			has             # check for presence of terminal utilities
			hyperfine       # binary benchmark
			imagemagick     # convert images
			jq              # json query language
			koji            # conventional git commits
			ncmpcpp         # music player
			newsboat        # RSS news reader
			pandoc          # file converter
			ripgrep         # fast grep
			taskwarrior-tui # taskwarrior tui
			taskwarrior3    # terminal todo
			tree            # see files in a dir
			vhs             # cool terminal gif maker
			wishlist        # ssh into different endpoints
			xh              # http request utility
			yt-dlp          # terminal YouTube
			lnav            # Log file viewer
		];
	};
}
