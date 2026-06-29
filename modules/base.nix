{ config, ... }: {
	flake.modules.homeManager.base = { pkgs, lib, ... }@hmArgs: {
		imports = with config.flake.modules.homeManager; [
			shell
			zsh
			tmux
			atuin
			direnv
			sh-prompt
			starship
			tealdeer
		];

		home.packages = with pkgs; [
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
			(lib.hiPrio less)  # busybox less lacks -r; override with GNU less
			calcure         # calendar
			coreutils-full  # all the coreutils
			delta           # diff pager for git
			dust            # check for space in disks
			ed              # the best text editor ever made
			entr            # run command on file change (watch→rebuild loop)
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
			nnn             # terminal file manager
			openssl         # key and cert generation
			pass            # password manager
			python3         # python
			sops            # secrets editor (age-encrypted yaml)
			unzip           # unzip files
			uutils-coreutils-noprefix   # uutils
		];

		# Expose PASSWORD_STORE_DIR to the systemd user session so GUI apps
		# (like protonmail-bridge) can find pass without being launched from zsh
		systemd.user.sessionVariables.PASSWORD_STORE_DIR =
			"${hmArgs.config.xdg.dataHome}/pass";
	};
}
