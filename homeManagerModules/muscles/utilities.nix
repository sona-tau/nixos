{
	config,
		pkgs,
		lib,
		...
}: {
	home.packages = with pkgs; [
		aerc            # terminal email
		bc              # calculator
		borgbackup      # backup software
		brightnessctl   # brightness manager
		btop            # task manager
		bunnyfetch      # cute system info display
		busybox         # install helpful terminal utilities
		calcure        # calendar
		cloc            # count lines of code
		coreutils-full  # all the coreutils
		delta           # diff pager for git
		discord         # Messaging app
		dust         # check for space in disks
		ed              # the best text editor ever made
		eza             # terminal ls
		fd              # better version of find
		feh             # image viewing software
		ffmpeg          # video editing software
		file            # check the type of a file
		firefoxpwa      # manage different PWAs with firefox
		fortune         # terminal thing
		gcc             # everything needs this
		gitui           # Terminal git interface
		git-lfs
		gimp            # image editing software
		glow            # markdown preview
		# gpt4all         # LLM interface
		grim slurp      # screenshots
		gum             # terminal forms
		has             # check for presence of terminal utilities
		hostsblock      # block ads at the /etc/hosts
		hugo            # website builder
		hydroxide       # proton email syncer
		hyperfine       # binary benchmark
		imagemagick     # convert images
		imv             # image viewing software
		inkscape        # vector editing software
		jq              # json query language
		koji            # conventional git commits
		lsof            # lsof to check outbound connections
		luajitPackages.lua-lsp  # lua-lsp for NeoVim
		mpv             # video playing software
		ncmpcpp         # music player
		nemo            # file picker
		neovide         # gui-nvim
		neovim          # the second best text editor ever made
		newsboat        # RSS news reader
		nnn             # terminal file manager
		obsidian        # for my Wiki
		ollama          # LLM manager
		pandoc          # file converter
		pavucontrol     # audio controller
		python3         # python
		rawtherapee     # image editing software
		ripgrep         # fast grep
		spotify         # music streaming service
		syncthing       # synchronize files
		taskwarrior-tui # taskwarrior tui
		taskwarrior3    # terminal todo
		tealdeer        # man but short
		tic-80          # fantasy computer emulator
		tmux            # terminal multiplexer
		tree            # see files in a dir
		typst           # Markdown + LaTex = typst compiler
		unzip           # unzip files
		ungoogled-chromium # Another browser
		uutils-coreutils-noprefix   # uutils
		vesktop         # discord emulator
		vhs             # cool terminal gif maker
		wishlist        # ssh into different endpoints
		xh              # http request utility
		yt-dlp          # terminal YouTube
		zathura         # pdf viewer
		elan            # theorem prover
		vscodium          # VEE ESS CODE
	];
}
