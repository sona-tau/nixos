{ ... }: {
	flake.modules.homeManager.offline-docs = { pkgs, ... }: {
		home.packages = with pkgs; [
			kiwix-tools      # Wikipedia (and other ZIM archives) via local HTTP
			cppreference-doc # C and C++ standard library reference
			nix-doc          # search nixpkgs function docs (complements manix for options)
		];

		# Expose cppreference HTML at a stable path independent of store hash
		home.file.".local/share/cppreference".source =
			"${pkgs.cppreference-doc}/share/cppreference/doc/html/en";

		# Systemd user service: serves ZIM archives from ~/Documents/kiwix/ on port 8000.
		# Starts automatically on login but only if the directory exists and has ZIM files.
		systemd.user.services.kiwix = {
			Unit = {
				Description = "Kiwix offline reader (port 8000)";
				# Won't start (silently) if no ZIM directory exists yet
				ConditionPathExists = "%h/Documents/kiwix";
			};
			Service = {
				ExecStart = "${pkgs.kiwix-tools}/bin/kiwix-serve %h/Documents/kiwix --port 8000";
				Restart = "on-failure";
				RestartSec = "5s";
			};
			Install.WantedBy = [ "default.target" ];
		};

		programs.zsh.initContent = ''
			# Open Wikipedia (or any ZIM) in w3m via local Kiwix server.
			# Starts the server on first use if it isn't already running.
			wiki() {
				if ! systemctl --user is-active --quiet kiwix 2>/dev/null; then
					if compgen -G "$HOME/Documents/kiwix/*.zim" >/dev/null 2>&1; then
						systemctl --user start kiwix && sleep 1
					else
						echo "No ZIM files in ~/Documents/kiwix/"
						echo "Download from: https://download.kiwix.org/zim/wikipedia/"
						return 1
					fi
				fi
				w3m http://localhost:8000
			}

			# C and C++ standard library reference (offline, no server needed)
			doc-cpp()  { w3m "$HOME/.local/share/cppreference/cpp/index.html" }
			doc-c()    { w3m "$HOME/.local/share/cppreference/c/index.html" }

			# Rust stdlib — requires: rustup component add rust-docs
			doc-rust() {
				local toolchain
				toolchain=$(rustup show active-toolchain 2>/dev/null | awk '{ print $1 }')
				local path
				path="$(rustup show home)/toolchains/$toolchain/share/doc/rust/html/std/index.html"
				if [[ -f "$path" ]]; then
					w3m "$path"
				else
					echo "Rust docs not installed. Run: rustup component add rust-docs"
				fi
			}

			# NixOS manual (always present after a rebuild)
			doc-nix() { w3m /run/current-system/sw/share/doc/nixos/manual.html }
		'';
	};
}
