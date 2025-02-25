{
    config,
    lib,
    ...
}: {
    programs = {
        direnv = {
            enable = true;
            enableZshIntegration = true;
            nix-direnv.enable = true;
        };

        starship = {
            enable = true;
            enableZshIntegration = true;
            settings = {
                add_newline = true;
                format = lib.concatStrings [
                    "[ ╭── ](white)[$hostname](purple)$directory\n"
                    "[ ╰ ](white)$character"
                ];
                right_format = lib.concatStrings [
                    "[$all](gray)"
                ];

    # Get editor completions based on the config schema
                "$schema" = "https://starship.rs/config-schema.json";

                character = { # The name of the module we are configuring is 'character'
                    success_symbol = "[λ](green)";
                    error_symbol = "[λ](red)";
                };

    # Disable the package module, hiding it from the prompt completely
                package.disabled = false;
            };
        };

        tealdeer = {
            enable = true;
            settings.updates.auto_update = true;
        };

        atuin = {
            enable = true;
            enableZshIntegration = true;
            settings = {
                auto_sync = true;
                sync_frequency = "5m";
                sync_address = "https://api.atuin.sh";
                search_mode = "prefix";
            };
        };

        zsh = {
            enable = true;
            enableCompletion = true;
            enableVteIntegration = true;
            autocd = true;
            autosuggestion.enable = true;
            shellAliases = {
                "compose" = "nvim \"$(mktemp --suffix .md)\"";
                "config" = "nvim \"~/nixos/hm-modules/rices/\"";
                "rebuild" = "doas nixos-rebuild -L --flake ~/nixos#fw13 --show-trace";
                "ls" = "eza";
                "rm" = "rm -i";
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
export TERMINAL="st"
export VIDEO="mpv"
export OPENER="xdg-open"
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
    };
}
