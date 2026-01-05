{ config, pkgs, lib, ... }: {
	config.programs.nushell = {
		extraConfig = ''
			def cfg [] {
				cd ~/.config/
				gum filter --fuzzy --sort --select-if-one | xargs -I {} nvim "/home/diego/.config/{}"
			}

			$env.config = {
				show_banner: false
					keybindings: [
						{
							name: change_dir_with_gum
							modifier: control
							keycode: char_f
							mode: [emacs, vi_insert, vi_normal]
							event: {
								send: executehostcommand,
								cmd: "cd (fd . -t d -d 3 --hidden | sed '/\\.git/d ; /\\.direnv/d' | gum filter --fuzzy --no-sort --select-if-one --strict)"
							}
						}
					]
			}

			# XDG directories
			$env.XDG_DATA_HOME = ($env.HOME | path join .local/share)
			$env.XDG_CONFIG_HOME = ($env.HOME | path join .config)
			$env.XDG_STATE_HOME = ($env.HOME | path join .local/state)
			$env.XDG_CACHE_HOME = ($env.HOME | path join .cache)

			# paths
			$env.MANPATH = ("/usr/local/texlive/2023/texmf-dist/doc/man"
				| prepend ($env.XDG_DATA_HOME | path join opam/default/man)
				| prepend ($env.XDG_DATA_HOME | path join
			texlive/2023/texmf-dist/doc/man)
			)
			$env.INFOPATH = ($env.MANPATH | split row (char esep)
				| prepend ($env.XDG_DATA_HOME | path join
			texlive/2023/texmf-dist/doc/info)
			)
			$env.CAML_LD_LIBRARY_PATH = ("/usr/lib/ocaml/stublibs"
				| prepend "/usr/lib/ocaml"
				| prepend ($env.XDG_DATA_HOME | path join opam/default/lib/stublibs)
			)
			$env.LD_LIBRARY_PATH = ("/usr/local/lib")
			$env.OCAML_TOPLEVEL_PATH = ($env.XDG_DATA_HOME | path join opam/default/lib/toplevel)
			$env.GOPATH = ($env.XDG_DATA_HOME | path join go)

			# My path
			$env.PATH = ($env.PATH | split row (char esep)
				| prepend "/usr/local/sbin"
				| prepend "/usr/local/bin"
				| prepend "/usr/bin"
				| prepend ($env.HOME | path join .local/bin)
				| prepend ($env.XDG_DATA_HOME | path join opam/default/bin)
				| prepend ($env.XDG_DATA_HOME | path join cargo/bin)
				| prepend ($env.XDG_DATA_HOME | path join cabal/bin)
				| prepend ($env.XDG_DATA_HOME | path join texlive/2023/bin/x86_64-linux)
			)

			# global env vars
			$env.TERM = xterm-256color
			$env.COLORTERM = truecolor
			$env.EDITOR = nvim
			$env.GTK_IM_MODULE = uim
			$env.LESSHISTFILE = -
			$env.NIXPKGS_ALLOW_UNFREE = 1
			$env.OPAM_SWITCH_PREFIX = ($env.XDG_DATA_HOME | path join opam/default)
			$env.OPENER = xdg-open
			$env.QT_IM_MODULE = uim
			$env.READER = zathura
			$env.TERMINAL = wezterm
			$env.VIDEO = mpv
			$env.VISUAL = nvim
			$env.WM = sway
			$env.XMODIFIERS = '@im=uim'
			$env.DEBUGINFOD_URLS = https://debuginfod.archlinux.org

			# wayland
			$env.GDK_BACKEND = wayland
			$env.MOZ_ENABLE_WAYLAND = 1
			$env.QT_QPA_PLATFORM = wayland
			$env.QT_QPA_PLATFORMTHEME = qt5ct

			# clean up home directory

			$env.XAUTHORITY = ($env.XDG_RUNTIME_DIR | path join Xauthority)
			$env.CABAL_CONFIG = ($env.XDG_DATA_HOME | path join cabal/config)
			$env.CABAL_DIR = ($env.XDG_DATA_HOME | path join cabal)
			$env.CARGO_HOME = ($env.XDG_DATA_HOME | path join cargo)
			$env.GHCUP_USE_XDG_DIRS = true
			$env.GNUPGHOME = ($env.XDG_DATA_HOME | path join gnupg)
			$env.OPAMROOT = ($env.XDG_DATA_HOME | path join opam)
			$env.PARALLEL_HOME = ($env.XDG_CONFIG_HOME | path join parallel)
			$env.PASSWORD_STORE_DIR = ($env.XDG_DATA_HOME | path join pass)
			$env.PYTHONSTARTUP = "/etc/python/pythonrc"
			$env.RUSTUP_HOME = ($env.XDG_DATA_HOME | path join rustup)
			$env.SPICETIFY_CONFIG = ($env.XDG_CONFIG_HOME | path join spicetify)
			$env.STACK_ROOT = ($env.XDG_DATA_HOME | path join stack)
			$env.STACK_XDG = 1
			$env.TERMINFO = ($env.XDG_DATA_HOME | path join terminfo)
			$env.TERMINFO_DIRS = ($env.XDG_DATA_HOME | path join terminfo
				| prepend "/usr/share/terminfo"
			)

			$env.TEXMFVAR = ($env.XDG_CACHE_HOME | path join texlive/texmf-var)
			$env.TEXMFHOME = ($env.XDG_DATA_HOME | path join texmf)
			$env.W3M_DIR = ($env.XDG_DATA_HOME | path join w3m)
			$env.WINEPREFIX = ($env.XDG_DATA_HOME | path join wine)
			$env.XINITRC = ($env.XDG_CONFIG_HOME | path join X11/xinitrc)
			$env._JAVA_OPTIONS = (["-Djava.util.prefs.userRoot=", $env.XDG_CONFIG_HOME, /java] | str join)
			$env.SYNC_CAL_DIR = ($env.HOME | path join Sync)
		'';

		shellAliases = {
			FUCK = "doas";
			FUCKING = "doas";
			# dots = "^ls -a | ^sort | ^uniq | gum filter | xargs nvim";
			code = "swayhide neovide --no-fork";
			ffmpreg = "ffmpeg";
			irssi = "irssi --config=$env.IRSSI_CONFIG --home=$env.IRSSI_DATA";
			neovide = "neovide";
			obsidian = "obsidian --ozone-platform-hint=auto";
			popd = "cd (skate get last-dir)";
			pushd = "skate set last-dir (pwd)";
			tmux = "tmux -2";
			wget = "wget --hsts-file=($env.XDG_DATA_HOME | path join wget-hsts)";
			tee = "^tee";
		};
	};
}
