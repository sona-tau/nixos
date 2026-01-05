{ config, lib, pkgs, ... }:
let
	cfg = config.my.applications;
in {
	options = {
		cfg.enableCliApps = lib.mkEnableOption "cli applications";
		cfg.enableExtraBrowsers = lib.mkEnableOption "extra browsers";
		cfg.enableExtraFonts = lib.mkEnableOption "extra fonts";
		cfg.enableExtraIcons = lib.mkEnableOption "extra icons";
	};

	config = {
		home.packages = with pkgs; [
			# gpt4all         # LLM interface
			brightnessctl   # brightness manager
			calcure         # calendar
			discord         # Messaging app
			feh             # image viewing software
			firefoxpwa      # manage different PWAs with firefox
			gimp            # image editing software
			grim slurp      # screenshots
			hostsblock      # block ads at the /etc/hosts
			imv             # image viewing software
			inkscape        # vector editing software
			mpv             # video playing software
			ncmpcpp         # music player
			nemo            # file picker
			neovide         # gui-nvim
			obsidian        # for my Wiki
			ollama          # LLM manager
			pavucontrol     # audio controller
			rawtherapee     # image editing software
			spotify         # music streaming service
			syncthing       # synchronize files
			taskwarrior-tui # taskwarrior tui
			taskwarrior3    # terminal todo
			tic-80          # fantasy computer emulator
			tofi            # wayland dmenu
			typst           # Markdown + LaTex = typst compiler
			ungoogled-chromium # Another browser
			vesktop         # discord emulator
			wl-clipboard    # clipboard management
			zathura         # pdf viewer
			swww            # simple wayland wallpaper woes
			mako            # wayland notification daemon
			libnotify       # this makes notifications work
		] ++ (if cfg.enableExtraBrowsers then with pkgs; [
			floorp-bin
		] else [])
		++ (if config.enableExtraIcons then with pkgs; [
			material-design-icons
			weather-icons
			gnomeExtensions.gtk4-desktop-icons-ng-ding
			nixos-icons
		] else [])
		++ (if config.enableExtraFonts then with pkgs; [
			apl386
			bqn386
			cozette
			dejavu_fonts
			fira-code-nerdfont
			ibm-plex
			ipaexfont
			ipafont
			linja-pi-pu-lukin
			nasin-nanpa
			nerdfonts
			ocr-a
			scientifica
			takao
		] else [])
		++ (if config.enableCliApps then with pkgs; [
			hyperfine       # binary benchmark
			cloc            # count lines of code
			delta           # diff pager for git
			clang-tools     # more C dev stuff
			gitui           # Terminal git interface
			git-lfs         # manage large files on git
			glow            # markdown preview
			gum             # terminal forms
			has             # check for presence of terminal utilities
			hugo            # website builder
			jq              # json query language
			koji            # conventional git commits
			luajitPackages.lua-lsp  # lua-lsp for NeoVim
			newsboat        # RSS news reader
			pandoc          # file converter
			tree            # see files in a dir
			unzip           # unzip files
			uutils-coreutils-noprefix   # uutils
			vhs             # cool terminal gif maker
			wishlist        # ssh into different endpoints
			xh              # http request utility
			yt-dlp          # terminal YouTube
		] else []);

		programs = {
			librewolf.enable = lib.mkIf config.enableExtraBrowsers true;
			lutris.enable = lib.mkIf config.enableGaming true;

			qutebrowser = lib.mkIf config.enableExtraBrowsers {
				enable = true;
				loadAutoconfig = true;

				extraConfig = ''
					c.url.default_page = "https://sadparadiseinhell.github.io/tea-green/"
					c.url.start_pages = ['https://baresearch.org']
				'';

				keyBindings.normal = {
					"<Ctrl-v>" = "spawn mpv {url}";
					"t" = "scroll-page 0 0.1";
					"n" = "scroll-page 0 -0.1";
				};

				searchEngines = {
					DEFAULT = "https://baresearch.org/search?q={}";
					w = "https://en.wikipedia.org/wiki/Special:Search?search={}";
					i = "https://baresearch.org/search?q={}&categories=images";
				};
			};
		};

		services.mako = {
			enable = true;
			borderRadius = 5;
			borderSize = 1;
			font = lib.mkForce "monospace";
			ignoreTimeout = true;
			extraConfig = "on-notify=exec mpv ~/Media/sound.opus";
		};

		home.sessionVariables = lib.mkIf cfg.enable {
			XDG_SESSION_TYPE = "wayland";
			GDK_BACKEND = "wayland";
			MOZ_ENABLE_WAYLAND = 1;
			QT_QPA_PLATFORM = "wayland";
			QT_QPA_PLATFORMTHEME = "qt5ct";
			NIXOS_OZONE_WL = "1";
		};
	};
}
