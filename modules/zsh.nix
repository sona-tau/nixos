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
        "ns" = "nix search nixpkgs";
        "twt" = "taskwarrior-tui";
        "calendar" = "khal interactive";
        "mail" = "aerc";
        "s" = "search";
        "powerwatch" =
          "watch -n5 'r1=$(cat /sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj); sleep 5; r2=$(cat /sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj); echo \"Package power: $(( (r2 - r1) / 5000000 )) W\"'";
        "turbostat" = "doas turbostat --interval 5 --quiet";
        "compose" = "nvim \"$(mktemp --suffix .md)\"";
        "config" = "neovide \"~/nixos/\"";
        "rebuild" = "doas env HOME=/root nixos-rebuild -L --flake ~/nixos --show-trace";
        "fuck" = "doas";
        "FUCK" = "doas";
        "FUCKING" = "doas";
        "shit" = "doas !!";
        "irssi" = "irssi --config=\"$XDG_CONFIG_HOME\"/irssi/config --home=\"$XDG_DATA_HOME\"/irssi";
        "ls" = "eza";
        "rm" = "rm -i";
      };

      initContent = ''
        # Open DuckDuckGo HTML results in w3m
        search() {
        	w3m "https://html.duckduckgo.com/html/?q=''${(j:+:)@}"
        }

        # Attach to the main tmux session, restoring from resurrect if saved,
        # or building the initial layout from scratch on first run.
        t() {
        	if tmux has-session -t main 2>/dev/null; then
        		exec tmux attach-session -t main
        	fi

        	local save="''${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect/last"

        	if [[ -e "$save" ]]; then
        		# Continuum will auto-restore when the server starts
        		exec tmux new-session -s main
        	fi

        	# First-ever launch: build the named-window layout
        	tmux new-session  -d -s main -n taskwarrior
        	tmux send-keys    -t main:taskwarrior "twt"                  Enter
        	tmux new-window   -t main -n wiki
        	tmux send-keys    -t main:wiki        "nvim ~/Documents/Wiki" Enter
        	tmux new-window   -t main -n calendar
        	tmux send-keys    -t main:calendar    "calendar"              Enter
        	tmux new-window   -t main -n mail
        	tmux send-keys    -t main:mail        "mail"                  Enter
        	tmux new-window   -t main -n search
        	tmux send-keys    -t main:search      "w3m"                   Enter
        	tmux new-window   -t main -n terminal
        	tmux select-window -t main:terminal
        	exec tmux attach-session -t main
        }

        mdpreview() {
        	local file="$1"
        	local pdf="/tmp/$(basename "''${file%.*}").pdf"
        	pandoc "$file" -o "$pdf" 2>/dev/null
        	zathura "$pdf" &
        	echo "$file" | entr pandoc "$file" -o "$pdf"
        }

        sysprofile() {
        	local dir="$HOME/.local/share/sysprofiles"
        	local out="$dir/$(date +%Y%m%d-%H%M%S)''${1:+-$1}.txt"
        	mkdir -p "$dir"
        	{
        		echo "=== SNAPSHOT: $(date) ''${1:+(label: $1)} ==="
        		echo ""
        		echo "--- boot time ---"
        		systemd-analyze
        		echo ""
        		echo "--- slowest boot units (top 15) ---"
        		systemd-analyze blame | head -15
        		echo ""
        		echo "--- running services ($(systemctl list-units --type=service --state=running --no-legend | wc -l) total) ---"
        		systemctl list-units --type=service --state=running --no-legend | awk '{print $1}'
        		echo ""
        		echo "--- memory ---"
        		free -h
        		echo ""
        		echo "--- top 20 by RAM ---"
        		ps aux | (read -r h; echo "$h"; sort -k4 -rn) | awk 'NR==1 || NR<=21 {printf "%-10s %5s %5s %s\n", $1, $3, $4, $11}'
        		echo ""
        		echo "--- top 20 by CPU ---"
        		ps aux | (read -r h; echo "$h"; sort -k3 -rn) | awk 'NR==1 || NR<=21 {printf "%-10s %5s %5s %s\n", $1, $3, $4, $11}'
        	} | tee "$out"
        	echo ""
        	echo "saved → $out"
        }

        sysdiff() {
        	local dir="$HOME/.local/share/sysprofiles"
        	local files=("$dir"/*)
        	local count=''${#files[@]}
        	if [[ $count -lt 2 ]]; then
        		echo "need at least 2 snapshots; run sysprofile first"
        		return 1
        	fi
        	diff --color=always "''${files[-2]}" "''${files[-1]}" | less -R
        }
        				'';

      envExtra = ''
        #  Wayland
        export QT_QPA_PLATFORM=wayland
        # XDG directories
        export XDG_DATA_HOME="$HOME/.local/share"
        export XDG_CONFIG_HOME="$HOME/.config"
        export XDG_STATE_HOME="$HOME/.local/state"
        export XDG_CACHE_HOME="$HOME/.cache"

        # paths
        export PATH="$HOME/.local/bin:$XDG_DATA_HOME/cargo/bin:$HOME/.cabal/bin:/opt/texlive/2023/bin/x86_64-linux:$HOME/.config/emacs/bin:$PATH"

        # global env vars
        export EDITOR="nvim"
        export ZK_NOTEBOOK_DIR="$HOME/Documents/Wiki"
        export READER="zathura"
        export VISUAL="nvim"
        export PAGER="bat"
        export TERMINAL="foot"
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
		export ZLE_RPROMPT_INDENT=0
        				'';
    };
  };
}
