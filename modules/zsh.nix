{ ... }: {
	flake.modules.homeManager.zsh = { config, lib, ... }: {
		programs.zsh = {
			enable = true;
				enableCompletion = true;
				enableVteIntegration = true;
				autocd = true;
				autosuggestion.enable = true;
				dotDir = "${config.xdg.configHome}/zsh";
				history.path = "${config.xdg.dataHome}/zsh/zsh_history";

				syntaxHighlighting = {
					enable = true;
					highlighters = [ "brackets" ];
				};

				shellAliases = {
					"compose" = "nvim \"$(mktemp --suffix .md)\"";
					"config" = "neovide \"~/nixos/\"";
					"rebuild" = "doas nixos-rebuild -L --flake ~/nixos --show-trace";
					"fuck" = "doas";
					"FUCK" = "doas";
					"FUCKING" = "doas";
					"shit" = "doas !!";
					"irssi" = "irssi --config=\"$XDG_CONFIG_HOME\"/irssi/config --home=\"$XDG_DATA_HOME\"/irssi";
					"ls" = "eza";
					"rm" = "rm -i";
				};

				# initExtra = ''~/.local/bin/sh_prompt'';

				envExtra = ''
#  Wayland
export QT_QPA_PLATFORM=wayland
# XDG directories
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# paths
export PATH="$HOME/.local/bin:$XDG_DATA_HOME/cargo/bin:$HOME/.cabal/bin:/opt/texlive/2023/bin/x86_64-linux:$PATH"

# global env vars
export EDITOR="nvim"
export READER="zathura"
export VISUAL="nvim"
export TERMINAL="st"
export VIDEO="mpv"
export OPENER="xdg-open"
export WM="dwm"
export LESSHISTFILE=-
export MANGOHUD=1
export TEXINPUTS=".:$HOME/casa/Documents/texpackages//::"
export COLORTERM=truecolor
export NIXPKGS_ALLOW_UNFREE=1
export NIXPKGS_ALLOW_BROKEN=1

# For cage
export XKB_DEFAULT_LAYOUT="mtgap-mod"

export CARGO_HOME="$XDG_DATA_HOME"/cargo
export DOT_SAGE="$XDG_CONFIG_HOME"/sage
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME"/npm
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME"/npm/config/npm-init.js
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR"/npm 
export OPAMROOT="$XDG_DATA_HOME/opam" 
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export SPICETIFY_CONFIG="$XDG_CONFIG_HOME/spicetify"
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:usr/share/terminfo
export W3M_DIR="$XDG_DATA_HOME"/w3m
export WINEPREFIX="$XDG_DATA_HOME"/wine
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export XCOMPOSECACHE="$XDG_CACHE_HOME"/X11/xcompose 
export XCURSOR_PATH=/urs/share/icons:"$XDG_DATA_HOME"/icons:"$XCURSOR_PATH"
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
				'';
		};
	};
}
