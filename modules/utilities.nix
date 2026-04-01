{ ... }: {
	flake.modules.homeManager.utilities = { config, pkgs, lib, ... }: let cfg = config.my.roles; in {
		options = {
			my.roles = {
				base.pkgSet.enable = lib.mkEnableOption "base package set";
				email.pkgSet.enable = lib.mkEnableOption "email package set";
				wayland.pkgSet.enable = lib.mkEnableOption "wayland package set";
				terminal.pkgSet.enable = lib.mkEnableOption "terminal package set";
				browsers.pkgSet.enable = lib.mkEnableOption "browsers package set";
				zen.pkgSet.enable = lib.mkEnableOption "zen package set";
				webdev.pkgSet.enable = lib.mkEnableOption "webdev package set";
				lean.pkgSet.enable = lib.mkEnableOption "lean package set";
				llm.pkgSet.enable = lib.mkEnableOption "llm package set";
				fun.pkgSet.enable = lib.mkEnableOption "fun package set";
				writing.pkgSet.enable = lib.mkEnableOption "writing package set";
			};
		};

		config = {
			home.packages = let
				base = with pkgs; [
					bat             # le pager
					bc              # calculator
					borgbackup      # backup software
					perkeep         # backup software
					rclone          # copying stuff
					brightnessctl   # brightness manager
					btop            # b top
					htop            # h top
					bunnyfetch      # cute system info display
					busybox         # install helpful terminal utilities
					calcure         # calendar
					coreutils-full  # all the coreutils
					delta           # diff pager for git
					dust            # check for space in disks
					ed              # the best text editor ever made
					eza             # terminal ls
					fd              # better version of find
					ffmpeg          # video editing software
					file            # check the type of a file
					gcc             # everything needs this
					git             # git
					gitlint
					pre-commit
					git-releaser
					git-revise
					gitleaks
					git-extras
					git-annex
					gitui           # Terminal git interface
					git-lfs         # git large file storage
					hostsblock      # block ads at the /etc/hosts
					lsof            # lsof to check outbound connections
					luajitPackages.lua-lsp  # lua-lsp for NeoVim
					mpv             # video playing software
					neovim          # the second best text editor ever made
					nnn             # terminal file manager
					pass            # password manager
					python3         # python
					tealdeer        # man but short
					tmux            # terminal multiplexer
					unzip           # unzip files
					uutils-coreutils-noprefix   # uutils
				];

				email = with pkgs; [
					aerc            # terminal email
					protonmail-export
					protonmail-bridge
					protonmail-bridge-gui
					protonmail-desktop
					thunderbird
				];

				wayland = with pkgs; [
					cage            # kiosk wayland
					discord         # Messaging app
					irssi           # also a messaging app
					feh             # image viewing software
					gimp            # image editing software
					grim slurp      # screenshots
					imv             # image viewing software
					inkscape        # vector editing software
					nemo            # file picker
					neovide         # gui-nvim
					libnotify       # notification daemon
					obsidian        # for my Wiki
					pavucontrol     # audio controller
					rawtherapee     # image editing software
					spotify         # music streaming service
					syncthing       # synchronize files
					zathura         # pdf viewer
					pdfpc           # really cool PDF presenter
					wl-clipboard    # for copy-pasting stuff
				];

				terminal = with pkgs; [
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

				browsers = with pkgs; [
					firefoxpwa      # manage different PWAs with firefox
					ungoogled-chromium # Another browser
				];

				zen = with pkgs; [
					fortune         # terminal thing
					cbonsai         # terminal bonsai
				];

				webdev = with pkgs; [
					hugo            # website builder
				];

				lean = with pkgs; [
					elan            # theorem prover
					vscodium        # VEE ESS CODE
				];

				llm = with pkgs; [
					# gpt4all         # LLM interface
					ollama          # LLM manager
				];

				fun = with pkgs; [
					cmatrix         # will you take the red pill, or the blue pill
					cowsay          # cow say
					steam           # video games
					tic-80          # fantasy computer emulator
					vesktop         # discord emulator
				];

				writing = with pkgs; [
					# texliveFull     # the whole LaTex suite
					typst           # Markdown + LaTex = typst compiler
				];
			in (if cfg.base.pkgSet.enable then base else [])
			++ (if cfg.email.pkgSet.enable then email else [])
			++ (if cfg.wayland.pkgSet.enable then wayland else [])
			++ (if cfg.terminal.pkgSet.enable then terminal else [])
			++ (if cfg.browsers.pkgSet.enable then browsers else [])
			++ (if cfg.zen.pkgSet.enable then zen else [])
			++ (if cfg.webdev.pkgSet.enable then webdev else [])
			++ (if cfg.lean.pkgSet.enable then lean else [])
			++ (if cfg.llm.pkgSet.enable then llm else [])
			++ (if cfg.fun.pkgSet.enable then fun else [])
			++ (if cfg.writing.pkgSet.enable then writing else []);
		};
	};
}
