{ config, pkgs, lib, ... }:
let cfg = config.zsh; in
{
	programs.zsh = {
            enableCompletion = true;
            enableVteIntegration = true;
            autocd = true;
            # autosuggestion = true;
            shellAliases = {
                "compose" = "nvim \"$(mktemp --suffix .eml)\"";
                "config" = "nvim \"~/nixos/hm-modules/rices/\"";
                "rebuild" = "doas nixos-rebuild -L --flake ~/nixos#fw13";
            };
            envExtra = ''
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
#export TERM="xterm-256color"
export TERMINAL="st"
export VIDEO="mpv"
export OPENER="xdg-open"
#export PAGER="bat -n -S --color always --italic-text always -P"
export WM="dwm"
export LESSHISTFILE=-
export MANGOHUD=1
export TEXINPUTS=".:$HOME/casa/Documents/texpackages//::"
export COLORTERM=truecolor
export NIXPKGS_ALLOW_UNFREE=1

export CARGO_HOME="$XDG_DATA_HOME"/cargo
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:usr/share/terminfo
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export SPICETIFY_CONFIG="$XDG_CONFIG_HOME/spicetify"
export W3M_DIR="$XDG_DATA_HOME"/w3m
export WINEPREFIX="$XDG_DATA_HOME"/wine
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
. "$XDG_DATA_HOME/cargo/env"
'';
	};
}

